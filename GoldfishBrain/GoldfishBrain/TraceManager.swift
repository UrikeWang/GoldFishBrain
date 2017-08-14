//
//  TraceManager.swift
//  
//
//  Created by yuling on 2017/8/14.
//
//

import Foundation
import Firebase
import SwiftyJSON

protocol traceManagerDelegete: class {

    func traceManager(_ manager: TraceManager, didGetEvent events: [Event])

    func traceManager(_ manager: TraceManager, didFailWith error: Error)

}

class TraceManager {

    weak var delegate: traceManagerDelegete?

    //swiftlint:disable force_cast
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    //swiftlint:enable force_cast

    func fetchFriendEvents() {

        let eventRef = Database.database().reference().child("events")

        eventRef.observeSingleEvent(of: .value, with: { (snapshot) in

            print("yoooo", snapshot.value)
            
            for userEvent in (snapshot.value as? [String: Any])! {
                
                if self.uid == userEvent.key {
                    
                    
                
                }
            }

        }, withCancel: nil)

    }

}
