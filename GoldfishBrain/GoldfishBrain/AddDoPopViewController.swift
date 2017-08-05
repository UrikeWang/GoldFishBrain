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
import Alamofire

class AddDoPopViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var publicTransportationButton: UIButton!

    @IBOutlet weak var carButton: UIButton!

    @IBOutlet weak var walkButton: UIButton!

    var locationManager = CLLocationManager()

    var currentLocation: CLLocation?

    var placesClient: GMSPlacesClient!

    var resultsViewController: GMSAutocompleteResultsViewController?

    var searchController: UISearchController?

    var resultView: UITextView?

    var routePoints = [String: [Double]]()

    @IBAction func popoverDone(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)

    }

    @IBAction func publicTransportationButton(_ sender: Any) {
    }

    @IBAction func carButton(_ sender: Any) {
    }

    @IBAction func walkButton(_ sender: Any) {
    }

    func calculateTravelTime(type: String) {

        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(routePoints["Start"]?[0]),\(routePoints["Start"]?[1])&destination=\(routePoints["End"]?[0]),\(routePoints["End"]?[1])&key=AIzaSyBAu1RqxhTwvzAD-ODP2KmDrpdT8BJwJxA"

        Alamofire.request(directionURL, method: .get, headers: <#T##HTTPHeaders?#>).responseJSON { _ in
            <#code#>
        }

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

        if routePoints["Start"] != nil && routePoints["End"] != nil {

            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: (routePoints["Start"]?[0])!, longitude: (routePoints["Start"]?[1])!))
            path.add(CLLocationCoordinate2D(latitude: (routePoints["End"]?[0])!, longitude: (routePoints["End"]?[1])!))

            let rectangle = GMSPolyline(path: path)
            rectangle.map = mapView

        }

        publicTransportationButton.setTitle("public", for: .normal)

        carButton.setTitle("car", for: .normal)

        walkButton.setTitle("walk", for: .normal)

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
