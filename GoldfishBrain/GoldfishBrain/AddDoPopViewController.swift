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

    var routeAddresses = [String: String]()

    var travelDetails = [TravelDetail]()

    @IBOutlet weak var travelTime: UITextView!

    @IBAction func popoverDone(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)

    }

    @IBAction func publicTransportationButton(_ sender: Any) {

        calculateTravelTime(type: "transit")
        //transit_mode=bus
    }

    @IBAction func carButton(_ sender: Any) {

        calculateTravelTime(type: "driving")
    }

    @IBAction func walkButton(_ sender: Any) {

        calculateTravelTime(type: "walking")
    }

    func calculateTravelTime(type: String) {

        if let start0 = routePoints["Start"]?[0] as? Double, let start1 = routePoints["Start"]?[1] as? Double, let end0 = routePoints["End"]?[0] as? Double, let end1 = routePoints["End"]?[1] as? Double {

            switch type {
            case "driving", "walking":
                let directionURL = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(start0),\(start1)&destinations=\(end0),\(end1)&mode=\(type)&key=AIzaSyBAu1RqxhTwvzAD-ODP2KmDrpdT8BJwJxA"

                Alamofire.request(directionURL, method: .get, parameters: nil).responseJSON { response in

                    switch response.result {

                    case .success(let data):

                        if let travelData = data as? [String: Any] {

                            if let route = travelData["rows"] as? [[String: Any]] {

                                if let detailData = route.first?["elements"] as? [[String: Any]] {

                                    if let duration = detailData.first?["duration"] as? [String: Any], let distance = detailData.first?["distance"] as? [String: Any] {

                                        if let durationText = duration["text"] as? String, let distanceText = distance["text"] as?String {

                                            print("qqqqqqqqq", durationText)

                                            print("pppppppp", distanceText)

                                            //swiftlint:disable force_cast
                                            let desination = self.routeAddresses["Destination"] as! String

                                            self.travelTime.text = "目的地：\(desination)\r\n總距離：\(distanceText)\r\n總時間：\(durationText)"
                                        }

                                    }

                                }

                            }

                        }

                    case .failure(let error):

                        print("Request failed with error: \(error)")

                    }

                }

            case "transit":

                let directionURL = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(start0),\(start1)&destinations=\(end0),\(end1)&mode=\(type)&key=AIzaSyBAu1RqxhTwvzAD-ODP2KmDrpdT8BJwJxA"

                Alamofire.request(directionURL, method: .get, parameters: nil).responseJSON { response in

                    switch response.result {

                    case .success(let data):

                        if let travelData = data as? [String: Any] {

                            if let route = travelData["rows"] as? [[String: Any]] {

                                if let detailData = route.first?["elements"] as? [[String: Any]] {

                                    if let duration = detailData.first?["duration"] as? [String: Any], let distance = detailData.first?["distance"] as? [String: Any] {

                                        if let durationText = duration["text"] as? String, let distanceText = distance["text"] as?String {

                                            print("qqqqqqqqq", durationText)

                                            print("pppppppp", distanceText)

                                            self.travelTime.text = "總距離：\(distanceText), 總時間：\(durationText)"
                                        }

                                    }

                                }

                            }

                        }

                    case .failure(let error):

                        print("Request failed with error: \(error)")

                    }

                }

            default: break

            }

        } else {

            print("You didn't select your destination")
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

//        fetchCurrentLocation()

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

//    func fetchCurrentLocation() {
//        
//        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//            
//            if let placeLikelihoodList = placeLikelihoodList {
//                for likelihood in placeLikelihoodList.likelihoods {
//                    let place = likelihood.place
//                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
//                    print("Current Place address \(place.formattedAddress)")
//                    print("Current Place attributions \(place.attributions)")
//                    print("Current PlaceID \(place.placeID)")
//                }
//            }
//        })
//    }

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
