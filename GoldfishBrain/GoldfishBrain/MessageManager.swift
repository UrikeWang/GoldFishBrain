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

    var talk: Message?

    weak var delegate: messageManagerDelegate?

    func observeUserMessages() {

        guard let uid = Auth.auth().currentUser?.uid else {

            print("somthing went wrong!")

            return

        }

        let ref = Database.database().reference().child("users").child(uid).child("chats")

        let channelRef = Database.database().reference().child("channels")

        ref.observe(.value, with: { (snapshot) in

            switch snapshot.childrenCount {

            case 0 :

                print("no chat contents!")

            case _ where snapshot.childrenCount > 0 :

                for chat in (snapshot.value as? [String: Any])! {

                    //channels ID
                    if let chatroomID = chat.key as? String {

                        channelRef.observeSingleEvent(of: .value, with: { (snapshot) in

                            for channel in (snapshot.value as? [String: Any])! {

                                if chatroomID == channel.key {

                                    channelRef.child(chatroomID).observe(.childAdded, with: { (snapshot) in

                                        if let dicts = snapshot.value as? [String: Any] {

                                            if let text = dicts["text"] as? String, let fromID = dicts["fromID"] as? String, let toID = dicts["toID"] as? String, let timestamp = dicts["timestamp"] as? Int {

                                                //                                                    self.talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)

                                                if fromID == uid || toID == uid {

                                                    if fromID == uid {

                                                        self.talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)

                                                    }

                                                    if toID == uid {

                                                        self.talk = Message(text: text, fromID: toID, toID: fromID, timestamp: timestamp)

                                                    }

                                                    //

//                                                    self.messagesdictionary[toID] = self.talk

                                                    self.messagesdictionary[chatroomID] = self.talk

                                                    self.messages = Array(self.messagesdictionary.values)

                                                    self.messages.sort(by: { (talk1, talk2) -> Bool in

                                                        return talk1.timestamp > talk2.timestamp

                                                    })

                                                    self.delegate?.messageManager(self, didGetMessage: self.messages)

                                                    print("???????", self.messages.count)

                                                }

                                            } else {

                                                print("Message data fetch failed")

                                            }

                                            //                                            }
                                        }

                                    }, withCancel: nil)

                                }
                            }

                        }, withCancel: nil)

                    }

                }

            default : break

            }

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
