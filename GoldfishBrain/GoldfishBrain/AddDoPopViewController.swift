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

protocol managerDestinationDelegate: class {

    func manager(_ manager: AddDoPopViewController, destination: String, duration: String, distance: String)
}

class AddDoPopViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var estimatedTitle: UILabel!

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

    var travelDuration = ""

    var travelDistance = ""

    var travelDestination = ""

    var detail: TravelDetail?

    weak var delegate: managerDestinationDelegate?

    //swiftlint:disable force_cast
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    //swiftlint:enable force_cast

    var notify = false

    @IBOutlet weak var travelTime: UITextView!

    @IBAction func popoverDone(_ sender: UIButton) {

        self.delegate?.manager(
            self,
            destination: travelDestination,
            duration: travelDuration,
            distance: travelDistance
        )

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

                                            //swiftlint:disable force_cast
                                            let desination = self.routeAddresses["Destination"] as! String
                                            //swiftlint:enable force_cast

                                            self.travelTime.text = "目的地：\(desination)\r\n總距離：\(distanceText)\r\n總時間：\(durationText)"

                                            self.travelDuration = "\(durationText)"

                                            self.travelDistance = "\(distanceText)"

                                            self.travelDestination = "\(desination)"

                                            var end00 = String(format: "%0.6f", end0)

                                            var end10 = String(format: "%0.6f", end1)

                                            UserDefaults.standard.set(end00, forKey: "destination0")

                                            UserDefaults.standard.set(end10, forKey: "destination1")

                                        }

                                    }

                                }

                            }

                        }

                    case .failure(let error):

                        print("Request failed with error: \(error)")

                    }

                }

            // TODO: transit
            case "transit": break

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

        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()

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

        estimatedTitle.text = "預估行程時間"

        travelTime.isScrollEnabled = true

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "showSelectedDestination" {
//
//            //swiftlint:disable force_cast
//            let VC = segue.destination as! CreateDoViewController
//            //swiftlint:enable force_cast
//
//            VC.travelDistance = self.travelDistance
//
//            VC.travelDuration = self.travelDuration
//
//            VC.travelDestination = self.travelDestination
//
//        }
//    }

}
