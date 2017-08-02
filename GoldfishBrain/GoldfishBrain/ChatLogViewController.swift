//
//  ChatLogViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/27.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseDatabase

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

    var textArray = [Message]()

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

    let uid = UserDefaults.standard.value(forKey: "uid")!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = peopleFirstName

        lastPageButton.title = "Return"

//        sendMessageView.addTopBorder()

        sendMessageButton.setTitle("Send", for: .normal)

        sendMessageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)

        messageText.placeholder = "Enter message..."

        messageText.font = UIFont.asiTextStyle11Font()

        self.messageText.delegate = self

        messageManager.delegate = self

//        messageManager.observeMessages()

        messageManager.observeUserMessages()

    }

    func handleSendMessage() {

        var istalked = false

        var isrun = Int()

        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/").child("messages")

            let timestamp = Int(Date().timeIntervalSince1970)

            let channelRef = Database.database().reference().child("channels")
//            let childRef = ref.childByAutoId()

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

                                    //swiftlint:disable force_cast
                                    let chatMember1 = member[0]

                                    let chatMember2 = member[1]
                                    //swiftlint:enable force_cast

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

                            print("!!!!!!!")

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

        handleSendMessage()

        return true
    }

    func messageManager(_ manager: MessageManager, didGetMessage message: [Message]) {

    }

    func messageManager(_ manager: MessageManager, didGetAllMessage allMessages: [Message]) {

        self.allMessages = allMessages

        DispatchQueue.main.async {

            self.chatLogTableView.reloadData()
        }

    }

    func messageManager(_ manager: MessageManager, didGetMessagesDict dict: [String: String]) {

        self.dict = dict

//        print("dict========", dict)

        if let chatroomID = dict[peopleID] {

            print("ID::", peopleID, chatroomID)

            if getChatroomID == false {
//
                getChatroomID = true

                messageManager.observeMessages(id: chatroomID)

            }
        }

    }

    func messageManager(_ manager: MessageManager, didFailWith error: Error) {

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allMessages.count

//        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLogCell", for: indexPath) as! ChatLogTableViewCell
        //swiftlint:enable force_cast

        let message = allMessages[indexPath.row]

        cell.chatText.text = message.text

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
