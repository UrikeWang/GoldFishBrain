//
//  AddDoPopViewController+GMSAutocompleteResults.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/5.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

extension AddDoPopViewController: GMSAutocompleteResultsViewControllerDelegate {

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false

        // Creates a marker in the center of the map
        let destinationMarker = GMSMarker()

        destinationMarker.position = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)

        destinationMarker.map = mapView

        destinationMarker.title = "Your destination"

        mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        routePoints["End"] = [place.coordinate.latitude, place.coordinate.longitude]

        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
