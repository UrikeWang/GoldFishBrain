//
//  ProfileManager.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/26.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol profileManagerDelegate: class {

    func profileManager(_ manager: ProfileManager, didGetProfile profile: [Profile])

    func profileManager(_ manager: ProfileManager, didFailWith error: Error)

}

class ProfileManager {

    weak var delegate: profileManagerDelegate?

    var profiles = [Profile]()

    func fetchProfile(uid: String) {

        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshop) in

            if let userData = snapshop.value as? [String: Any] {

                if let firstName = userData["firstName"] as? String,
                    let lastName = userData["lastName"] as? String,
                    let email = userData["email"] as? String {

                    self.profiles.append(Profile(uid: uid, firstName: firstName, lastName: lastName, email: email))

                    self.delegate?.profileManager(self, didGetProfile: self.profiles)
                }

            }

        }, withCancel: nil)

    }

}
