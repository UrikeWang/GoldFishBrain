//
//  AddDoPopViewController+extension.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/3.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import Firebase

extension AddDoPopViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {

        case .restricted:
            print("Location access was restricted.")

        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false

        case .notDetermined:
            print("Location status not determined.")

        case .authorizedWhenInUse: fallthrough

        case .authorizedAlways:
            locationManager.startMonitoringSignificantLocationChanges()

            locationManager.startUpdatingLocation()

            mapView.isMyLocationEnabled = true

            mapView.settings.myLocationButton = true

            //            print("Location status is OK.")

                    }

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        mapView.clear()

        mapView.camera = GMSCameraPosition(target: (location?.coordinate)!, zoom: 15, bearing: 0, viewingAngle: 0)

        // Creates a marker in the center of the map
        let marker = GMSMarker()

        marker.position = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)

        marker.title = "Here you are"

        routePoints["Start"] = [(location?.coordinate.latitude)!, (location?.coordinate.longitude)!]

        marker.map = mapView

    }

//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//
//        print("enter")
//
//    }
//
//    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
//
//        print("exit")
//    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("error:: \(error.localizedDescription)")
    }

//    func autoResponse(destination: String, id: String) {
//
//        var istalked = false
//
//        var isrun = Int()
//
//        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
//
//            let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/").child("messages")
//
//            let timestamp = Int(Date().timeIntervalSince1970)
//
//            let channelRef = Database.database().reference().child("channels")
//            //            let childRef = ref.childByAutoId()
//
//            let childTalkRef = channelRef.childByAutoId()
//
//            let chatsRef = Database.database().reference().child("users").child(uid).child("chats")
//
//            let chatsToRef =  Database.database().reference().child("users").child(id).child("chats")
//
//            let childTalkTextID = childTalkRef.childByAutoId()
//
//            chatsRef.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                switch snapshot.childrenCount {
//
//                case 0 :
//
//                    let memValues = ["0": uid, "1": id]
//
//                    let values = ["text": "我到達\(destination)", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]
//
//                    childTalkRef.child("members").updateChildValues(memValues)
//
//                    childTalkTextID.updateChildValues(values)
//
//                    //                    self.messageText.text = ""
//
//                    chatsRef.updateChildValues([childTalkRef.key: 1])
//
//                    chatsToRef.updateChildValues([childTalkRef.key: 1])
//
//                case _ where snapshot.childrenCount > 0 :
//
//                    isrun = Int(snapshot.childrenCount)
//
//                    for chat in (snapshot.value as? [String: Any])! {
//
//                        //channels ID
//                        if let chatroomID = chat.key as? String {
//
//                            channelRef.observeSingleEvent(of:.value, with: { (dataSnapshot) in
//
//                                if let member = dataSnapshot.childSnapshot(forPath: chatroomID).childSnapshot(forPath: "members").value as? [String] {
//
//                                    let chatMember1 = member[0]
//
//                                    let chatMember2 = member[1]
//
//                                    if (uid == chatMember1 && id == chatMember2) || (uid == chatMember2 && id == chatMember1) {
//
//                                        istalked = true
//
//                                        let values = ["text": "我到達\(destination)", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]
//
//                                        channelRef.child(chatroomID).childByAutoId().updateChildValues(values)
//
//                                    }
//
//                                    isrun -= 1
//
//                                }
//
//                                if istalked == false && isrun == 0 {
//
//                                    let memValues = ["0": uid, "1": id]
//
//                                    let values = ["text": "我到達\(destination)", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]
//
//                                    childTalkRef.child("members").updateChildValues(memValues)
//
//                                    childTalkTextID.updateChildValues(values)
//
//                                    //                                    self.messageText.text = ""
//
//                                    chatsRef.updateChildValues([childTalkRef.key: 1])
//
//                                    chatsToRef.updateChildValues([childTalkRef.key: 1])
//
//                                    istalked = true
//
//                                }
//
//                            }, withCancel: nil)
//
//                        }
//
//                    }
//
//                default: break
//
//                }
//
//            }, withCancel: nil)
//
//        }
//
//    }

}
