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
            
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        mapView.clear()

        mapView.camera = GMSCameraPosition(target: (location?.coordinate)!, zoom: 15, bearing: 0, viewingAngle: 0)

//        // Creates a marker in the center of the map
//        let marker = GMSMarker()
//
//        marker.position = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
//
//        marker.title = "Here you are"
//        
//        marker.map = mapView

        routePoints["Start"] = [(location?.coordinate.latitude)!, (location?.coordinate.longitude)!]

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

}
