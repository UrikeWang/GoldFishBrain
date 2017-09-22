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
        mapView.clear()

        searchController?.isActive = false

        searchController?.searchBar.text = place.formattedAddress

        mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        //選取地點之後，會先預設為走路
        routePoints["End"] = [place.coordinate.latitude, place.coordinate.longitude]

        calculateTravelTime(type: "walking")

        walkButton.layer.borderWidth = 1
        walkButton.layer.borderColor = UIColor.goldfishRed.cgColor
        walkButton.tintColor = UIColor.goldfishRed

        carButton.layer.borderColor = UIColor.clear.cgColor
        carButton.tintColor = UIColor.darkGray

        // Creates a marker in the center of the map
        let destinationMarker = GMSMarker()

        destinationMarker.position = CLLocationCoordinate2DMake((routePoints["End"]?[0])!, (routePoints["End"]?[1])!)

        destinationMarker.map = mapView

        destinationMarker.title = "Your destination"

        routeAddresses["Destination"] = "\(place.formattedAddress!)"

    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error) {

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
