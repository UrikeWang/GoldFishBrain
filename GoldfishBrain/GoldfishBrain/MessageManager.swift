//
//  MessageManager.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/28.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

protocol messageManagerDelegate: class {

    func messageManager(_ manager: MessageManager, didGetMessage message: [Message])

    func messageManager(_ manager: MessageManager, didFailWith error: Error)

}

class MessageManager {

    var messages = [Message]()

    var messagesdictionary = [String: Message]()

    weak var delegate: messageManagerDelegate?

    func observeUserMessages() {

        guard let uid = Auth.auth().currentUser?.uid else {

            print("somthing went wrong!")

            return

        }

        let ref = Database.database().reference().child("user-messages").child(uid)

            ref.observe(.childAdded, with: { (snapshot) in

            let messageID = snapshot.key

            let messagesRef = Database.database().reference().child("messages")/*.child(messageID)*/

            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in

                for message in (snapshot.value as? [String: AnyObject])! {

//                    print("snapshot.value", message)

                    if let dicts = message.value as? [String: Any] {

                        if let text = dicts["text"] as? String, let fromID = dicts["fromID"] as? String, let toID = dicts["toID"] as? String, let timestamp = dicts["timestamp"] as? Int {

                            let talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)

//                            self.messages.append(talk)

//                            print("where is dic???", talk)

                            if fromID == Auth.auth().currentUser?.uid || toID == Auth.auth().currentUser?.uid {

                                if toID == talk.toID {

                                    self.messagesdictionary[toID] = talk

                                    self.messages = Array(self.messagesdictionary.values)

                                    self.messages.sort(by: { (talk1, talk2) -> Bool in

                                        // TODO: 修正最後訊息顯示
                                        //                                    print("talk1", talk1.timestamp, talk1.text)
                                        //
                                        //                                    print("talk2", talk2.timestamp, talk2.text)

                                        return talk1.timestamp > talk2.timestamp

                                    })

                                self.delegate?.messageManager(self, didGetMessage: self.messages)

                                }

                            }

                        } else {

                            print("Message data fetch failed")

                        }

                    }
                }

            }, withCancel: nil)

        }, withCancel: nil)

    }

//    func observeMessages() {
//
//        let ref = Database.database().reference()
//
//        ref.observe(.childAdded, with: { (snapshot) in
//
//            for message in (snapshot.value as? [String: AnyObject])! {
//
//                if let dicts = message.value as? [String: Any] {
//
//                    if let text = dicts["text"] as? String, let fromID = dicts["fromID"] as? String, let toID = dicts["toID"] as? String, let timestamp = dicts["timestamp"] as? Int {
//
//                        let talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)
//
//                        self.messages.append(talk)
//
////                        print("talkkk", talk)
//
//                        if toID == talk.toID {
//
//                            self.messagesdictionary[toID] = talk
//
//                            self.messages = Array(self.messagesdictionary.values)
//
//                            self.messages.sort(by: { (talk1, talk2) -> Bool in
//
//                                return talk1.timestamp.hashValue > talk2.timestamp.hashValue
//                            })
//
//                        }
//
//                        self.delegate?.messageManager(self, didGetMessage: self.messages)
//
//                    } else {
//
//                        print("Message data fetch failed")
//
//                    }
//
//                }
//
//            }
//
//        }, withCancel: nil)
//
//    }

}
