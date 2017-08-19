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

    func chatRoomManager(_ manager: ChatRoomManager, didGetFriend friend: Person)

}

class ChatRoomManager {

    weak var delegate: chatRoomManagerDelegate?

    var people = [Person]()

    var friend: Person?

//    func fetchPeople() {
//
//        let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/").child("users")
//
//        ref.observeSingleEvent(of:.value, with: { (snapshot: DataSnapshot) in
//
//            for user in (snapshot.value as? [String: AnyObject])! {
//
//                if let dict = user.value as? [String: AnyObject] {
//
//                    if let firstName = dict["firstName"] as? String, let lastName = dict["lastName"] as? String, let imageUrl = dict["profileImageURL"] as? String {
//
//                        let man = Person(id: user.key, firstName: firstName, lastName: lastName, imageUrl: imageUrl)
//
//                        self.people.append(man)
//
//                        self.delegate?.chatRoomManager(self, didGetPeople: self.people)
//
//                    } else {
//
//                        print("Data fetch failed")
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

    func searchFriend(email: String) {

        let ref = Database.database().reference().child("users")

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            for user in (snapshot.value as? [String: AnyObject])! {

                if let dict = user.value as? [String: AnyObject] {

                    if let userEmail = dict["email"] as? String {

                        if userEmail == email {

                            guard let firstName = dict["firstName"] as? String, let lastName = dict["lastName"] as? String, let imageUrl = dict["profileImageURL"] as? String

                                else {

                                    print("此mail不存在")

                                    return

                            }

                            self.friend = Person(id: user.key, firstName: firstName, lastName: lastName, imageUrl: imageUrl)

                            print("friend??????", self.friend)

                            self.delegate?.chatRoomManager(self, didGetFriend: self.friend!)

                        }

                    }

                }

            }

        })

    }

    func addFriend(friend: Person) {

        let ref = Database.database().reference().child("users").child(uid).child("friends")

        ref.observeSingleEvent(of: .value, with: { (_) in

            let values = ["\(friend.id)": 1]

            ref.updateChildValues(values)

        })

        let friendRef = Database.database().reference().child("users").child(friend.id).child("friends")

        friendRef.observeSingleEvent(of: .value, with: { (_) in

            let values = ["\(uid)": 1]

            friendRef.updateChildValues(values)

        })

    }
}
