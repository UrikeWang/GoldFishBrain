//
//  MessageManager.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/28.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol messageManagerDelegate: class {

    func messageManager(_ manager: MessageManager, didGetMessage message: [Message])

    func messageManager(_ manager: MessageManager, didFailWith error: Error)

}

class MessageManager {

    var messages = [Message]()

    var messagesdictionary = [String: Message]()

    weak var delegate: messageManagerDelegate?

    func observeMessages() {

        let ref = Database.database().reference()

        ref.observe(.childAdded, with: { (snapshot) in

            for message in (snapshot.value as? [String: AnyObject])! {

                if let dicts = message.value as? [String: Any] {

                    if let text = dicts["text"] as? String, let fromID = dicts["fromID"] as? String, let toID = dicts["toID"] as? String, let timestamp = dicts["timestamp"] as? Int {

                        let talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)

                        self.messages.append(talk)

//                        if let toIDs = talk.toID {
//                            
//                            self.messagesdictionary[toIDs] = talk
//                        
//                        }

                        self.delegate?.messageManager(self, didGetMessage: self.messages)

                    } else {

                        print("Message data fetch failed")

                    }

                }

            }

        }, withCancel: nil)

    }

}
