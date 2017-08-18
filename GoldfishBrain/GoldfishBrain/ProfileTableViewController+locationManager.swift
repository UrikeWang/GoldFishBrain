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

//        Analytics.logEvent(<#T##name: String##String#>, parameters: <#T##[String : Any]?#>)

//        if doCoordinate.isEmpty == false {

//            let marker = GMSMarker()
//
//            marker.position = CLLocationCoordinate2DMake(doCoordinate[0] as CLLocationDegrees, doCoordinate[1] as CLLocationDegrees)
//            marker.map = mapView
//
//        mapView.reloadInputViews()

//        }

    }

//    func manager(_ manager: CreateDoViewController, destination: String, duration: String, distance: String, coordinate: [Double]) {
//
//        self.doDestination = destination
//
//        self.doDuration = duration
//
//        self.doDistance = distance
//
//        self.doCoordinate = coordinate
//
//    }

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

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        mapView.clear()

        mapView.camera = GMSCameraPosition(target: (location?.coordinate)!, zoom: 15, bearing: 0, viewingAngle: 0)

        mapView.isMyLocationEnabled = true

        mapView.settings.myLocationButton = true

        if destinationCoordinates.isEmpty == false {

            let destination = CLLocation(latitude: destinationCoordinates[0] as CLLocationDegrees, longitude: destinationCoordinates[1] as CLLocationDegrees)

            let distance: CLLocationDistance = location!.distance(from: destination)

            print("outttttttt notified", isNotified)

            if isNotified[0] == 0 {

                if let friendID = UserDefaults.standard.value(forKey: "friendID") as? String, let userDestination = UserDefaults.standard.value(forKey: "destination") as? String {

                switch distance {
                case 0...100:

                    isNotified[0] = 1

                    print("我在附近了！！！！")
                    print("innnnn notified", isNotified)
                    autoResponse(destination: userDestination, id: friendID)

                    doingCoreDataManager.updateDoingDo()

//                    locationManager.stopUpdatingLocation()

                default:
                    print("nonononono")
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

        print("location:::", coordinate)

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
//        print("exit~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
//    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("error: \(error.localizedDescription)")
    }

    func autoResponse(destination: String, id: String) {

        var istalked = false

        var isrun = Int()

        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

//            _ = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/").child("messages")

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

                    let values = ["text": "我快到 \(destination) 拉！！！", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

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
