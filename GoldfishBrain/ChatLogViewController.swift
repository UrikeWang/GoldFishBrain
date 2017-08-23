//
//  ChatLogViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/27.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseDatabase
//import JSQMessagesViewController

class ChatLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, messageManagerDelegate {

    var people = [Person]()

    var peopleFirstName = ""

    var peopleLastName = ""

    var peopleID = ""

    var allMessages: [Message] = []

    var dict = [String: String]()

    var messageCount = 0

    var messageManager = MessageManager()

    var getChatroomID = false

//    var textArray = [Message]()

    @IBOutlet weak var sendMessageView: UIView!

    @IBOutlet weak var messageText: UITextField!

    @IBOutlet weak var sendMessageButton: UIButton!

    @IBOutlet weak var chatLogTableView: UITableView!

    @IBOutlet weak var lastPageButton: UIBarButtonItem!

    @IBAction func lastPageButton(_ sender: Any) {

        dismiss(animated: true)

        peopleLastName = ""

        peopleFirstName = ""
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        
        if messageText.text != "" {
            
            handleSendMessage()
            
        }
    }
    

    //swiftlint:disable force_cast
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    //swiftlint:enable force_cast

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed
        navigationItem.title = peopleFirstName
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationController?.navigationBar.tintColor = UIColor.white

        lastPageButton.title = "Back"

        sendMessageButton.setImage(UIImage(named: "ic_done.png"), for: .normal)
        sendMessageButton.backgroundColor = UIColor.asiGreyish
        sendMessageButton.tintColor = UIColor.white

        if messageText.text != "" {

            sendMessageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)

        }

        messageText.placeholder = "Enter message..."
        messageText.font = UIFont.asiTextStyle11Font()
        messageText.backgroundColor = UIColor.asiGreyish

        self.messageText.delegate = self

        messageManager.delegate = self

//        messageManager.observeMessages()

        messageManager.observeUserMessages()

        chatLogTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        chatLogTableView.estimatedRowHeight = 86.0
        chatLogTableView.rowHeight = UITableViewAutomaticDimension

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {

            self.moveToLastComment()
        }
    }

    func moveToLastComment() {

        if self.chatLogTableView.contentSize.height > self.chatLogTableView.frame.height {
            // First figure out how many sections there are
            let lastSectionIndex = self.chatLogTableView!.numberOfSections - 1

            // Then grab the number of rows in the last section
            let lastRowIndex = self.chatLogTableView!.numberOfRows(inSection: lastSectionIndex) - 1

            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)

            // Make the last row visible
            self.chatLogTableView?.scrollToRow(at: pathToLastRow as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
        }
    }

    func handleSendMessage() {

        var istalked = false

        var isrun = Int()

        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            let timestamp = Int(Date().timeIntervalSince1970)

            let channelRef = Database.database().reference().child("channels")

            let childTalkRef = channelRef.childByAutoId()

            let chatsRef = Database.database().reference().child("users").child(uid).child("chats")

            let chatsToRef =  Database.database().reference().child("users").child(peopleID).child("chats")

            let childTalkTextID = childTalkRef.childByAutoId()

            chatsRef.observeSingleEvent(of: .value, with: { (snapshot) in

                switch snapshot.childrenCount {

                case 0 :

                    let memValues = ["0": uid, "1": self.peopleID]

                    let values = ["text": self.messageText.text, "fromID": uid, "toID": self.peopleID, "timestamp": timestamp] as [String : Any]

                    childTalkRef.child("members").updateChildValues(memValues)

                    childTalkTextID.updateChildValues(values)

                    self.messageText.text = ""

                    chatsRef.updateChildValues([childTalkRef.key: 1])

                    chatsToRef.updateChildValues([childTalkRef.key: 1])

                case _ where snapshot.childrenCount > 0 :

                    isrun = Int(snapshot.childrenCount)

                    for chat in (snapshot.value as? [String: Any])! {

                        //channels ID
                        if let chatroomID = chat.key as? String {

                            channelRef.observeSingleEvent(of:.value, with: { (dataSnapshot) in

                                if let member = dataSnapshot.childSnapshot(forPath: chatroomID).childSnapshot(forPath: "members").value as? [String] {

                                    let chatMember1 = member[0]

                                    let chatMember2 = member[1]

                                    if (uid == chatMember1 && self.peopleID == chatMember2) || (uid == chatMember2 && self.peopleID == chatMember1) {

                                        istalked = true

                                        let values = ["text": self.messageText.text, "fromID": uid, "toID": self.peopleID, "timestamp": timestamp] as [String : Any]

                                        channelRef.child(chatroomID).childByAutoId().updateChildValues(values)

                                        self.messageText.text = ""
                                    }

                                    isrun -= 1

                                }

                                if istalked == false && isrun == 0 {

                                    let memValues = ["0": uid, "1": self.peopleID]

                                    let values = ["text": self.messageText.text, "fromID": uid, "toID": self.peopleID, "timestamp": timestamp] as [String : Any]

                                    childTalkRef.child("members").updateChildValues(memValues)

                                    childTalkTextID.updateChildValues(values)

                                    self.messageText.text = ""

                                    chatsRef.updateChildValues([childTalkRef.key: 1])

                                    chatsToRef.updateChildValues([childTalkRef.key: 1])

                                    istalked = true

                                }

                            }, withCancel: nil)

                        }

                    }

                default: break

                }

            }, withCancel: nil)

        }

    }

    //按完return鍵能自動送出message
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        if messageText.text != "" {

            handleSendMessage()

        }

        return true
    }

    func messageManager(_ manager: MessageManager, didGetMessage message: [Message]) {

    }

    func messageManager(_ manager: MessageManager, didGetAllMessage allMessages: [Message]) {

        self.allMessages = allMessages

        DispatchQueue.main.async {

            self.chatLogTableView.reloadData()

            let pathToLastRow = NSIndexPath(row: allMessages.count - 1, section: 0)

            // Make the last row visible
            self.chatLogTableView?.scrollToRow(at: pathToLastRow as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)

        }

    }

    func messageManager(_ manager: MessageManager, didGetMessagesDict dict: [String: String]) {

        self.dict = dict

        if let chatroomID = dict[peopleID] {

            if getChatroomID == false {

                getChatroomID = true

                messageManager.observeMessages(id: chatroomID)

            }
        }

    }

    func messageManager(_ manager: MessageManager, didFailWith error: Error) {

        print("message log \(error)")

    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return allMessages.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = allMessages[indexPath.row]

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MM-dd HH:mm"

        dateFormatter.timeZone = TimeZone.current

        let date = Date(timeIntervalSince1970: TimeInterval(message.timestamp))

        let strDate = dateFormatter.string(from: date)

        if message.fromID == uid {

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatLogCell", for: indexPath) as! RightChatLogTableViewCell
            //swiftlint:enable force_cast

            cell.rightChatText.text = message.text

            cell.setNeedsUpdateConstraints()

            cell.updateConstraintsIfNeeded()

            cell.rightChatTimeLabel.text = strDate

            return cell

        } else {

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChatLogCell", for: indexPath) as! LeftChatLogTableViewCell
            //swiftlint:enable force_cast

            cell.leftChatText.text = message.text

            cell.setNeedsUpdateConstraints()

            cell.updateConstraintsIfNeeded()

            cell.leftChatTimeLabel.text = strDate

            return cell

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
