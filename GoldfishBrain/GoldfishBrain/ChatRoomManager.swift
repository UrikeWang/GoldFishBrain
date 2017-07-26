//
//  ChatRoomManager.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/26.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol chatRoomManagerDelegate: class {

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person])

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: Error)

}

class ChatRoomManager {

    weak var delegate: chatRoomManagerDelegate?

    var people = [Person]()

    func fetchPeople() {

        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in

                for user in snapshot.children {

                    let dict = user as? [String: AnyObject]

                    if let firstName = dict?["firstName"] as? String, let lastName = dict?["lastName"] as? String {

                        let man = Person(id: snapshot.key, firstName: firstName, lastName: lastName)

                        self.people.append(man)
                        
                        print("QQQQQ", self.people)

                    }

                    //                    let man = Person(dictionary: [String : Any])

                    //                    do {
                    //
                    //                        let man = Person(dictionary: user)
                    //
                    //                        man.setValuesForKeys(dictionary)
                    //
                    //                        self.people.append(man)
                    //
                    //                    } catch(let error) {
                    //
                    //                        print(error)
                    //
                    //                    }

                }

                //            }
                DispatchQueue.main.async {

                    self.delegate?.chatRoomManager(self, didGetPeople: self.people)

                }
//            }

        }, withCancel: nil)

    }
}
