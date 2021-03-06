//
//  ChatRoomManager.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/26.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import FirebaseDatabase
import NVActivityIndicatorView

protocol chatRoomManagerDelegate: class {

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person])

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: String)

    func chatRoomManager(_ manager: ChatRoomManager, didGetFriend friend: Person)

}

class ChatRoomManager {

    weak var delegate: chatRoomManagerDelegate?

    var friend: Person?

    func fetchFriendIDs() {

        let activityData = ActivityData()

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        let ref = Database.database().reference().child("users").child(uid)

            ref.child("friends").observe(.value, with: { (snapshot: DataSnapshot) in

                guard let userList  = snapshot.value as? [String: AnyObject] else { return }

                var friendIDs = [String]()

                for user in userList {

                    friendIDs.append(user.key)

                }

                self.fetchPeople(friendIDs: friendIDs)

            }, withCancel: nil)

    }

    func fetchPeople(friendIDs: [String]) {

        var people = [Person]()

        let ref = Database.database().reference().child("users")

        for friendID in friendIDs {

            let friendRef = ref.child(friendID)

            friendRef.observeSingleEvent(of:.value, with: { (snapshot: DataSnapshot) in

                let dict = snapshot.value as? [String: Any]

                if let firstName = dict?["firstName"] as? String, let lastName = dict?["lastName"] as? String, let imageUrl = dict?["profileImageURL"] as? String {

                    let man = Person(id: friendID, firstName: firstName, lastName: lastName, imageUrl: imageUrl)

                    people.append(man)

                    DispatchQueue.main.async {

                        self.delegate?.chatRoomManager(self, didGetPeople: people)
                    }

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

                }

            }, withCancel: nil)

        }

    }

    func searchFriend(email: String) {

        var found = false

        let ref = Database.database().reference().child("users")

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            for user in (snapshot.value as? [String: AnyObject])! {

                if let dict = user.value as? [String: AnyObject] {

                    if let userEmail = dict["email"] as? String {

                        if userEmail == email {

                            guard let firstName = dict["firstName"] as? String, let lastName = dict["lastName"] as? String, let imageUrl = dict["profileImageURL"] as? String

                                else {

                                    return

                            }

                            found = true

                            self.friend = Person(id: user.key, firstName: firstName, lastName: lastName, imageUrl: imageUrl)

                            self.delegate?.chatRoomManager(self, didGetFriend: self.friend!)

                        }

                    }

                }

            }

            if found == false {

                self.delegate?.chatRoomManager(self, didFailWith: "此mail不存在，或是大小寫有誤，請再次確認朋友的Email")

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
