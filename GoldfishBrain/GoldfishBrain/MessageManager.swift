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

        let ref = Database.database().reference()

        ref.observe(.childAdded, with: { (snapshot) in

//            print("111111111", snapshot)
//
//            print("22222222", snapshot.key)
//
//            print("33333333", snapshot.value)

            for message in (snapshot.value as? [String: AnyObject])! {

               print("mmmmmmmmm", message)

                if let dicts = message.value as? [String: Any] {

                    print("44444444", dicts)

                    //swiftlint:disable force_cast
//                    let dict = dicts as! [String: String]
                    //swiftlint:enable force_cast

                    if let text = dicts["text"] as? String, let fromID = dicts["fromID"] as? String, let toID = dicts["toID"] as? String, let timestamp = dicts["timestamp"] as? Int {

                        let talk = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp)

                        self.messages.append(talk)

                        print("5555555555", talk)

                        self.delegate?.messageManager(self, didGetMessage: self.messages)

                    } else {

                        print("Data fetch failed")

                    }

                }

            }

        }, withCancel: nil)

    }

}
