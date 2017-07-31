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

    var messages = [Message]()

    var messageManager = MessageManager()

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

        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/").child("messages")

            let timestamp = Int(Date().timeIntervalSince1970)

            let talkChannelRef = Database.database().reference().child("channels")
//            let childRef = ref.childByAutoId()

            let childTalkRef = talkChannelRef.childByAutoId()

            let chatsRef = Database.database().reference().child("users").child(uid).child("chats")

            let chatsToRef =  Database.database().reference().child("users").child(peopleID).child("chats")

            let childTalkTextID = childTalkRef.childByAutoId()

            chatsRef.observe(.value, with: { (snapshot) in

                print("???????????", snapshot)

                if snapshot.childrenCount > 0 {

                    print("value:::::", snapshot.value!)
                    print("1111111111", snapshot.childrenCount)

                    print("222222222", childTalkRef.child("members").child("1"))

//                    if (childTalkRef.child("members").child("1") = uid && childTalkRef.child("members").child("0")) || (childTalkRef.child("members").child("0") = uid && childTalkRef.child("members").child("1")) {
//                    
//                        childTalkTextID.updateChildValues(values)
//                    }

                } else {

                    let memValues = ["o": uid, "1": self.peopleID]

                    let values = ["text": self.messageText.text, "fromID": uid, "toID": self.peopleID, "timestamp": timestamp, "talkChannel": childTalkRef.key] as [String : Any]

//                    let values = [["text": self.messageText.text, "fromID": uid, "toID": self.peopleID, "timestamp": timestamp, "talkChannel": childTalkRef.key], "members": [uid, self.peopleID]] as [String : Any]

                    childTalkRef.child("members").updateChildValues(memValues)

                    childTalkTextID.updateChildValues(values)

                    chatsRef.updateChildValues([childTalkRef.key: 1])

                    chatsToRef.updateChildValues([childTalkRef.key: 1])

                }

            }, withCancel: nil)

//            print("!!!!??????", childTalkRef.key)

//            if talkChannelRef.key == "\(uid) + \(self.peopleID)" || talkChannelRef.key == "\(self.peopleID) + \(uid)" {

//                childRef.updateChildValues(values, withCompletionBlock: { (error, _) in
//                    
//                    if error != nil {
//                        
//                        print(error)
//                        
//                        return
//                    }

//                    //將同一個人發的message 存在同一個child中，並將message一併存起來
//                    let userMessagesRef = Database.database().reference().child("user-messages").child("\(uid)")
//                    
//                    let messageID = childRef.key
//                    
//                    userMessagesRef.updateChildValues([messageID: 1])
//                    
//                    //同時將message存到對方的child中
//                    let recipientUserMessageRef = Database.database().reference().child("user-messages").child(self.peopleID)
//                    
//                    recipientUserMessageRef.updateChildValues([messageID: 1])

//                })

//            }
////        else {
//                
//                let talkChannelRef = Database.database().reference().child("channels").child("\(uid) + \(self.peopleID)")
//                
//                let values = ["text": self.messageText.text, "fromID": uid, "toID": self.peopleID, "timestamp": timestamp, "talkChannel": "\(uid) + \(self.peopleID)"]
////
//                talkChannelRef.updateChildValues(values)
//
//                    childRef.updateChildValues(values, withCompletionBlock: { (error, _) in
//
//                        if error != nil {
//
//                            print(error)
//
//                            return
//                        }

//                        //將同一個人發的message 存在同一個child中，並將message一併存起來
//                        let userMessagesRef = Database.database().reference().child("user-messages").child("\(uid)")
//
//                        let messageID = childRef.key
//
//                        userMessagesRef.updateChildValues([messageID: 1])
//
//                        //同時將message存到對方的child中
//                        let recipientUserMessageRef = Database.database().reference().child("user-messages").child(self.peopleID)
//
//                        recipientUserMessageRef.updateChildValues([messageID: 1])

//                    })
//
//                }
//
//            }, withCancel: nil)
//            }
        }

    }

    //按完return鍵能自動送出message
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        handleSendMessage()

        return true
    }

    func messageManager(_ manager: MessageManager, didGetMessage message: [Message]) {

        self.messages = message

//        print("::::::::::", message)

        DispatchQueue.main.async {

            self.chatLogTableView.reloadData()
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
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLogCell", for: indexPath) as! ChatLogTableViewCell
        //swiftlint:enable force_cast

        let message = messages[indexPath.row]

//        let refUser = Database.database().reference().child("users").child(peopleID)
//        
//        let refMessage = Database.database().reference().child("messages")
//        
//        refUser.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let dict = snapshot.value as? [String: AnyObject] {
//            
//                
//            }
//            
//        }, withCancel: nil)

        if let toID = message.toID as? String {

            let ref = Database.database().reference().child("users").child(toID)

            ref.observeSingleEvent(of: .value, with: { (snapshot) in

                if let dict = snapshot.value as? [String: AnyObject] {

                    cell.chatNameText.text = dict["firstName"] as? String
                }

            }, withCancel: nil)

        }

        cell.chatText.text = messages[indexPath.row].text

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
