//
//  AddDoPopViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/2.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddDoPopViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!

    var locationManager = CLLocationManager()

    var currentLocation: CLLocation?

    var placesClient: GMSPlacesClient!

    @IBAction func popoverDone(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)

//        darkView.isHidden = true
    }

    func nearbyPlaces() {

        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }

            if let placeLikelihoodList = placeLikelihoodList {

                for likelihood in placeLikelihoodList.likelihoods {

                    let place = likelihood.place
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    //                    print("Current Place address \(place.formattedAddress)")
                    //                    print("Current Place attributions \(place.attributions)")
                    //                    print("Current PlaceID \(place.placeID)")
                }
            }
        })

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialize the location manager
        locationManager = CLLocationManager()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest

//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        locationManager.distanceFilter = 50

        locationManager.startUpdatingLocation()

        locationManager.delegate = self

        locationManager.requestLocation()

        //Initialize the GMSPlacesClient
        placesClient = GMSPlacesClient.shared()

        self.nearbyPlaces()

//        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!, zoom: 6.0)

//
//        self.mapView.camera = camera
//        

//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//
//        marker.title = "Sydney"
//
//        marker.snippet = "Australia"
//
//        marker.map = mapView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
