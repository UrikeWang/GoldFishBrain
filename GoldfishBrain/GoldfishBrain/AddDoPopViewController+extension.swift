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

        case .authorizedAlways: fallthrough

        case .authorizedWhenInUse:

            // 4
            locationManager.startUpdatingLocation()

            //5
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
//            print("Location status is OK.")
        }

    }

    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("past", locations)

        if let location = locations.last {

            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

            // Creates a marker in the center of the map
            let marker = GMSMarker()

            marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)

            marker.title = "Here you are"

            routePoints["Start"] = [location.coordinate.latitude, location.coordinate.longitude]

//            routeAddresses["Start"] = "\(location.address)"

            marker.map = mapView

            // 8
            locationManager.stopUpdatingLocation()

        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("error:: \(error.localizedDescription)")
    }

}
