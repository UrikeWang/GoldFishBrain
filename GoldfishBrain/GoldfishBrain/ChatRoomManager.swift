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

        Database.database().reference().child("users").observe(.value, with: { (snapshot: DataSnapshot) in
            
            print("data?", snapshot)

                for user in (snapshot.value as AnyObject).allValues {

                    let dict = user as? [String: AnyObject]
                    
//                    print("data??", dict)

                    if let firstName = dict?["firstName"] as? String, let lastName = dict?["lastName"] as? String {

                        let man = Person(id: snapshot.key, firstName: firstName, lastName: lastName)

                        self.people.append(man)
                        
//                        print("QQQQQ", self.people)

                    }
                    
                    else {
                        
                        print("failed!!")
                    }

                }

                DispatchQueue.main.async {

                    self.delegate?.chatRoomManager(self, didGetPeople: self.people)

                }

        }, withCancel: nil)

    }
}
