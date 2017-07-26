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

        let ref = Database.database().reference()

//        ref.child(uid).observeSingleEvent(of: .value, with: { (snapshop) in
//            
//            
//            
//        }, withCancel: nil)

        ref.child("users").observe(.value, with: { (snapshot: DataSnapshot) in

            for user in (snapshot.value as AnyObject).allValues {

//                print("!!!!", (snapshot.value as AnyObject).keyPath )

                let dict = user as? [String: AnyObject]

                if let firstName = dict?["firstName"] as? String, let lastName = dict?["lastName"] as? String {

                    let man = Person(id: snapshot.key, firstName: firstName, lastName: lastName)

                    self.people.append(man)

                } else {

                    print("Data fetch failed")
                }

            }

            DispatchQueue.main.async {

                self.delegate?.chatRoomManager(self, didGetPeople: self.people)

            }

        }, withCancel: nil)

    }
}
