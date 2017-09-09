//
//  ProfileTableViewController+locationManager.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/12.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
import Firebase

extension ProfileTableViewController: CLLocationManagerDelegate {

    func manager(_ manager: CreateDoViewController, didGestDestinationCoordinate coordinate: [Double]) {

        self.doCoordinate = coordinate

    }

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

        case .authorizedWhenInUse:
            locationManager.startMonitoringSignificantLocationChanges()

            locationManager.startUpdatingLocation()

        case .authorizedAlways:
            locationManager.startMonitoringSignificantLocationChanges()

            locationManager.startUpdatingLocation()

        }

         Analytics.logEvent("轉換地點權限", parameters: ["ChangeAuthorization": status])

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        Analytics.logEvent("使用者地點", parameters: ["UserCurrentLocation": location as Any])

        mapView.clear()

        mapView.camera = GMSCameraPosition(target: (location?.coordinate)!, zoom: 15, bearing: 0, viewingAngle: 0)

        mapView.isMyLocationEnabled = true

        mapView.settings.myLocationButton = true

        let marker = GMSMarker()

        marker.position = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)

        marker.title = "我的位置"

        marker.map = mapView

        if destinationCoordinates.isEmpty == false {

            let destination = CLLocation(latitude: destinationCoordinates[0] as CLLocationDegrees, longitude: destinationCoordinates[1] as CLLocationDegrees)

            let distance: CLLocationDistance = location!.distance(from: destination)

            if isNotified[0] == 0 {

                if let friendID = UserDefaults.standard.value(forKey: "friendID") as? String, let userDestination = UserDefaults.standard.value(forKey: "destination") as? String {

                    switch distance {
                    case 0...100:

                        isNotified[0] = 1

                        autoResponse(destination: userDestination, id: friendID)

                        doingCoreDataManager.updateDoingDo()

                        //                    locationManager.stopUpdatingLocation()

                    default:
                        print("out of destination for 100 meters")
                    }

                }
            }
        }

        //        print("from tab bar", tabBarC?.destinationCoordinates)

    }

    func startMonitoring() {

        locationManager.startUpdatingLocation()

    }

    func checkUserCurrentDestination(coordinate: [Double]) {

        let coordinate2D = CLLocationCoordinate2D(latitude: coordinate[0] as CLLocationDegrees, longitude: coordinate[1] as CLLocationDegrees)

        let title = "Destination"

        let regionRadius = 100.0

        let region = CLCircularRegion(center: coordinate2D, radius: regionRadius, identifier: title)

        locationManager.startMonitoring(for: region)

        region.notifyOnEntry = true

    }

//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//
//        print("enter")
//
//        if let friendID = UserDefaults.standard.value(forKey: "friendID") as? String, let userDestination = UserDefaults.standard.value(forKey: "destination") as? String {
//
//            if isNotified == false {
//
//                autoResponse(destination: userDestination, id: friendID)
//
//                isNotified = true
//
//                locationManager.stopMonitoring(for: region)
//
//                let alertController = UIAlertController(title: "區域通知", message: "進來拉 radius = 100", preferredStyle: .alert)
//
//                let check = UIAlertAction(title: "OK", style: .default) { (_ : UIAlertAction) in
//
//                    alertController.dismiss(animated: true, completion: nil)
//                }
//
//                alertController.addAction(check)
//
//                doingCoreDataManager.updateDoingDo()
//
////                var doingTravelDatas = [DoingTravelDataMO]()
////                
////                doingTravelDatas = doingCoreDataManager.fetchDoingData()
////                
////                doingCount = doingTravelDatas.count
//
//                self.present(alertController, animated: true, completion: nil)
//
//            }
//
//        }
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//
//        print("exit")
//    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("error: \(error.localizedDescription)")
    }

    func autoResponse(destination: String, id: String) {

        var istalked = false

        var isrun = Int()

        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            let timestamp = Int(Date().timeIntervalSince1970)

            let channelRef = Database.database().reference().child("channels")

            let childTalkRef = channelRef.childByAutoId()

            let chatsRef = Database.database().reference().child("users").child(uid).child("chats")

            let chatsToRef =  Database.database().reference().child("users").child(id).child("chats")

            let childTalkTextID = childTalkRef.childByAutoId()

            chatsRef.observeSingleEvent(of: .value, with: { (snapshot) in

                switch snapshot.childrenCount {

                case 0 :

                    let memValues = ["0": uid, "1": id]

                    let values = ["text": "我快到 \(destination) 拉！！！", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                    childTalkRef.child("members").updateChildValues(memValues)

                    childTalkTextID.updateChildValues(values)

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

                                        let values = ["text": "我到達快到\(destination) 拉！！", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                                        channelRef.child(chatroomID).childByAutoId().updateChildValues(values)

                                    }

                                    isrun -= 1

                                }

                                if istalked == false && isrun == 0 {

                                    let memValues = ["0": uid, "1": id]

                                    let values = ["text": "我到達快到\(destination)拉！", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                                    childTalkRef.child("members").updateChildValues(memValues)

                                    childTalkTextID.updateChildValues(values)

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
