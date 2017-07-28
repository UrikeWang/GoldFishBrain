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

    weak var delegate: messageManagerDelegate?

    func observeMessages() {

        let ref = Database.database().reference().child("message")

        ref.observe(.childAdded, with: { (snapshot) in

            for message in (snapshot.value as? [String: AnyObject])! {

                if let dict = message.value as? [String: String] {

                    if let fromID = dict["fromID"], let text = dict["text"], let toID = dict["toID"], let timestamp = dict["timeStamp"] {

                        let talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)

                        self.messages.append(talk)

                        self.delegate?.messageManager(self, didGetMessage: self.messages)

                    } else {

                        print("Data fetch failed")

                    }

                    print("message:::::", message)

                }

            }

        }, withCancel: nil)

    }

}
