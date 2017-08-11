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

        //swiftlint:disable force_cast
        let addDoVC = CreateDoViewController()
        //swiftlint:enable force_cast

        addDoVC.delegate = self

        print("where??????????", doCoordinate)

//        checkUserCurrentDestination(coordinate: doCoordinate)

        //            locationManager.stopUpdatingLocation()

        //            var location00 = String(format: "%0.6f", location.coordinate.latitude)
        //
        //            var location10 = String(format: "%0.6f", location.coordinate.longitude)
        //
        //            if let userDestination0 = UserDefaults.standard.value(forKey: "destination0") as? String, let userDestination1 = UserDefaults.standard.value(forKey: "destination1") as? String, let userDestination = UserDefaults.standard.value(forKey: "destination") as? String, let friendID = UserDefaults.standard.value(forKey: "friend") as? String {
        //
        //                if notify == false && location00 == userDestination0 && location10 == userDestination1 && location00 != "" {
        //
        //                    print("i'm here")
        //
        //                    autoResponse(destination: userDestination, id: friendID)
        //
        //                    locationManager.stopUpdatingLocation()
        //
        //                    notify == true
        //                }
        //
        //            }

    }

    func checkUserCurrentDestination(coordinate: [Double]) {

//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {

            let title = "Destination"

//            let coordinate = coordinate

            let coordinate = CLLocationCoordinate2D(latitude: coordinate[0] as CLLocationDegrees, longitude: coordinate[1] as CLLocationDegrees)

            print("location:::", coordinate)

            let regionRadius = 300.0

            let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: title)

        region.notifyOnEntry = true

            locationManager.startMonitoring(for: region)
//
//        } else {
//
//            print("System can't track regions")
//        }

    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

        if let userDestination = UserDefaults.standard.value(forKey: "destination") as? String, let friendID = UserDefaults.standard.value(forKey: "friend") as? String {

            autoResponse(destination: userDestination, id: friendID)

        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("error:: \(error.localizedDescription)")
    }

    func autoResponse(destination: String, id: String) {

        var istalked = false

        var isrun = Int()

        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/").child("messages")

            let timestamp = Int(Date().timeIntervalSince1970)

            let channelRef = Database.database().reference().child("channels")
            //            let childRef = ref.childByAutoId()

            let childTalkRef = channelRef.childByAutoId()

            let chatsRef = Database.database().reference().child("users").child(uid).child("chats")

            let chatsToRef =  Database.database().reference().child("users").child(id).child("chats")

            let childTalkTextID = childTalkRef.childByAutoId()

            chatsRef.observeSingleEvent(of: .value, with: { (snapshot) in

                switch snapshot.childrenCount {

                case 0 :

                    let memValues = ["0": uid, "1": id]

                    let values = ["text": "我到達\(destination)", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                    childTalkRef.child("members").updateChildValues(memValues)

                    childTalkTextID.updateChildValues(values)

                    //                    self.messageText.text = ""

                    chatsRef.updateChildValues([childTalkRef.key: 1])

                    chatsToRef.updateChildValues([childTalkRef.key: 1])

                case _ where snapshot.childrenCount > 0 :

                    isrun = Int(snapshot.childrenCount)

                    for chat in (snapshot.value as? [String: Any])! {

                        //channels ID
                        if let chatroomID = chat.key as? String {

                            channelRef.observeSingleEvent(of:.value, with: { (dataSnapshot) in

                                if let member = dataSnapshot.childSnapshot(forPath: chatroomID).childSnapshot(forPath: "members").value as? [String] {

                                    let chatMember1 = member[0]

                                    let chatMember2 = member[1]

                                    if (uid == chatMember1 && id == chatMember2) || (uid == chatMember2 && id == chatMember1) {

                                        istalked = true

                                        let values = ["text": "我到達\(destination)", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                                        channelRef.child(chatroomID).childByAutoId().updateChildValues(values)

                                    }

                                    isrun -= 1

                                }

                                if istalked == false && isrun == 0 {

                                    let memValues = ["0": uid, "1": id]

                                    let values = ["text": "我到達\(destination)", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                                    childTalkRef.child("members").updateChildValues(memValues)

                                    childTalkTextID.updateChildValues(values)

                                    //                                    self.messageText.text = ""

                                    chatsRef.updateChildValues([childTalkRef.key: 1])

                                    chatsToRef.updateChildValues([childTalkRef.key: 1])

                                    istalked = true

                                }

                            }, withCancel: nil)

                        }

                    }

                default: break

                }

            }, withCancel: nil)

        }

    }

}
