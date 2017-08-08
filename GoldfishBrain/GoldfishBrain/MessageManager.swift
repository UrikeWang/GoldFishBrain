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

    func messageManager(_ manager: MessageManager, didGetAllMessage allMessages: [Message])

    func messageManager(_ manager: MessageManager, didGetMessagesDict dict: [String: String])

    func messageManager(_ manager: MessageManager, didFailWith error: Error)

}

class MessageManager {

    var messages = [Message]()

    var messagesdictionary = [String: Message]()

    var allMessagesdictionary = [String: [Message]]()

    var roomDict = [String: String]()

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

                                                if fromID == uid || toID == uid {

                                                    if fromID == uid {

                                                        self.talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)

                                                        self.roomDict[toID] = chatroomID

                                                    }

                                                    if toID == uid {

                                                        self.talk = Message(text: text, fromID: toID, toID: fromID, timestamp: timestamp)

                                                        self.roomDict[fromID] = chatroomID

                                                    }

                                                    self.messagesdictionary[chatroomID] = self.talk

                                                    self.messages = Array(self.messagesdictionary.values)

                                                    self.messages.sort(by: { (talk1, talk2) -> Bool in

                                                        return talk1.timestamp > talk2.timestamp

                                                    })

                                                    self.delegate?.messageManager(self, didGetMessage: self.messages)

                                                    self.delegate?.messageManager(self, didGetMessagesDict: self.roomDict)

                                                }

                                            } else {

                                                print("Message data fetch failed")

                                            }

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

    func observeMessages(id: String) {

        let ref = Database.database().reference().child("channels").child(id)

        ref.observe(.value, with: { (snapshot) in

            var allMessages = [Message]()

            for child in (snapshot.value as? [String: AnyObject])! {

                if let dicts = child.value as? [String: Any] {

                    if let text = dicts["text"] as? String, let fromID = dicts["fromID"] as? String, let toID = dicts["toID"] as? String, let timestamp = dicts["timestamp"] as? Int {

                        let talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)

                        allMessages.append(talk)

                        allMessages.sort(by: { (talk1, talk2) -> Bool in

                            return talk1.timestamp < talk2.timestamp

                        })

                        self.delegate?.messageManager(self, didGetAllMessage: allMessages)

                    }
                }

            }

        }, withCancel: nil)

    }

}
