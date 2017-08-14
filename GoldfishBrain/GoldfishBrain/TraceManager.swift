//
//  TraceManager.swift
//  
//
//  Created by yuling on 2017/8/14.
//
//

import Foundation
import Firebase

protocol traceManagerDelegete: class {

    func traceManager(_ manager: TraceManager, didGetEvent events: [Event])

    func traceManager(_ manager: TraceManager, didFailWith error: Error)

}

class TraceManager {

    weak var delegate: traceManagerDelegete?

    //swiftlint:disable force_cast
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    //swiftlint:enable force_cast

    var event: Event?

    var events = [Event]()

    func fetchFriendEvents() {

        let eventRef = Database.database().reference().child("events").child(uid).queryOrdered(byChild: "duration")

        eventRef.observeSingleEvent(of: .value, with: { (snapshot) in

            guard let autoIDListSource = snapshot.value as? [String: Any] else { return }

//            for (key, value) in autoIDListSource {

            for event in autoIDListSource {

                guard let details = event.value as? [String: Any] else { return }

                if let time = details["time"] as? String, let destination = details["destination"] as? String, let duration = details["duration"] as? String, let fromFriend = details["fromFriend"] as? String {

//                    let userFirstName = self.fetchFriendFirstName(fromFriend: fromFriend)

                    let userRef = Database.database().reference().child("users").child(fromFriend).child("firstName")

                    userRef.observe(.value, with: { (snapshot) in

                        if let userFirstName = snapshot.value as? String {

                            self.event = Event(destination: destination, duration: duration, fromFriend: userFirstName, time: time)

                            self.events.append(self.event!)

                            self.delegate?.traceManager(self, didGetEvent: self.events)

                        }

                    })

                }

            }

        }, withCancel: nil)

    }

//    func fetchFriendFirstName(fromFriend: String) -> String {
//        
//        if fromFriend != "" {
//            
//            print("2222")
//            
//            let userRef = Database.database().reference().child("users").child(fromFriend).child("firstName")
//            
//            userRef.observe(.value, with: { (snapshot) in
//                
//                return snapshot
//            })
//        
//        } else {
//            
//            return uid
//        
//        }
//
//    }

}
