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

    var resultsViewController: GMSAutocompleteResultsViewController?

    var searchController: UISearchController?

    var resultView: UITextView?

    @IBAction func popoverDone(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)

    }

//    func nearbyPlaces() {
//
//        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//
//            if let placeLikelihoodList = placeLikelihoodList {
//
//                for likelihood in placeLikelihoodList.likelihoods {
//
//                    let place = likelihood.place
//                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
//                    //                    print("Current Place address \(place.formattedAddress)")
//                    //                    print("Current Place attributions \(place.attributions)")
//                    //                    print("Current PlaceID \(place.placeID)")
//                }
//            }
//        })
//
//    }

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

//        //附近地點
//        self.nearbyPlaces()

        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        let subView = UIView(frame: CGRect(x: 0, y: 0.0, width: 350, height: 45.0))

        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

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
