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
        // 3
        if status == .authorizedWhenInUse {

            // 4
//            locationManager.startUpdatingLocation()

            //5
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }

    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {

            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

            // Creates a marker in the center of the map
            let marker = GMSMarker()

            marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)

            marker.title = "Here you are"

            routePoints["Start"] = [location.coordinate.latitude, location.coordinate.longitude]

//            print("points", routePoints)

            marker.map = mapView

            // 8
//            locationManager.stopUpdatingLocation()

//            // Create request
//            let request = MKDirectionsRequest()
//            request.source = sourceMapItem
//            request.destination = destinationMapItem
//            request.transportType = MKDirectionsTransportType.Automobile
//            request.requestsAlternateRoutes = false
//            let directions = MKDirections(request: request)
//            directions.calculateDirectionsWithCompletionHandler { response, error in
//                if let route = response?.routes.first {
//                    print("Distance: \(route.distance), ETA: \(route.expectedTravelTime)")
//                } else {
//                    print("Error!")
//                }
//            }
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("error:: \(error.localizedDescription)")
    }

}
