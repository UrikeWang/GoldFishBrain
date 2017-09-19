//
//  TraceManager.swift
//  
//
//  Created by yuling on 2017/8/14.
//
//

import Foundation
import Firebase
import NVActivityIndicatorView

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

    func fetchFriendEvents() {
        
        let activityData = ActivityData()
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        let eventRef = Database.database().reference().child("events").child(uid)//.queryOrdered(byChild: "duration")

        eventRef.observe(.value, with: { (snapshot) in

            var events = [Event]()

//            for (key, value) in autoIDListSource {

            if snapshot.childrenCount == 0 {

                events = []

                self.delegate?.traceManager(self, didGetEvent: events)
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            } else {

                guard let autoIDListSource = snapshot.value as? [String: Any] else { return }

                for event in autoIDListSource {

                    guard let details = event.value as? [String: Any] else { return }

                    if let time = details["time"] as? String, let destination = details["destination"] as? String, let duration = details["duration"] as? String, let fromFriend = details["fromFriend"] as? String, let eventID = event.key as? String {

                        let userRef = Database.database().reference().child("users").child(fromFriend).child("firstName")

                        userRef.observe(.value, with: { (snapshot) in

                            if let userFirstName = snapshot.value as? String {

                                self.event = Event(destination: destination, duration: duration, fromFriend: userFirstName, time: time, eventID: eventID, fromFriendID: fromFriend)

                                events.append(self.event!)

                                self.delegate?.traceManager(self, didGetEvent: events)
                                
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

                            }

                        })

                    }

                }

            }

        }, withCancel: nil)

    }

    func deleteFriendEvent(deleteEventID: String) {

        let eventRef = Database.database().reference().child("events").child(uid).child(deleteEventID)

        eventRef.removeValue()

    }

}
