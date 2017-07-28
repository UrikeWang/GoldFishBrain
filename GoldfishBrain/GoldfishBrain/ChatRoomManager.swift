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

        let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/").child("users")
        
        ref.observe(.value, with: { (snapshot: DataSnapshot) in

//        ref.child("users").observe(.value, with: { (snapshot: DataSnapshot) in

            for user in (snapshot.value as AnyObject).allValues {
            
//            for user in (snapshot.value as? [String: AnyObject])! {
            
                print("!!!!!", snapshot.value)

//                snapshot.key
                
                let dict = user as? [String: AnyObject]

                if let firstName = dict?["firstName"] as? String, let lastName = dict?["lastName"] as? String, let imageUrl = dict?["profileImageURL"] as? String {

                    let man = Person(id: snapshot.key, firstName: firstName, lastName: lastName, imageUrl: imageUrl)

                    self.people.append(man)
                    
                    print("??????", man)

                    self.delegate?.chatRoomManager(self, didGetPeople: self.people)

                } else {

                    print("Data fetch failed")
                }

            }

//            DispatchQueue.main.async {
//
//                self.delegate?.chatRoomManager(self, didGetPeople: self.people)
//
//            }

        }, withCancel: nil)

    }
}
