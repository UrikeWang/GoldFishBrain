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
import Firebase

protocol managerDestinationDelegate: class {

    func manager(_ manager: AddDoPopViewController, destination: String, duration: String, distance: String, coordinate: [Double])
}

class AddDoPopViewController: UIViewController/*, managerCreateStartDelegate*/ {

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

    var doDestination = ""

    var doDuration = ""

    var doDistance = ""

    var doCoordinate = [Double]()

    var notify = false

    @IBOutlet weak var travelTime: UITextView!

    @IBOutlet weak var popoverDone: UIButton!

    @IBOutlet weak var popoverCancel: UIButton!

    @IBAction func popoverDone(_ sender: UIButton) {

        if travelTime.text == "" {

            let alertController = UIAlertController(
                title: "溫馨小提醒",
                message: "請選取交通方式",
                preferredStyle: .alert)

            let check = UIAlertAction(title: "OK", style: .default, handler: { (_ : UIAlertAction) in
                alertController.dismiss(animated: true, completion: nil)
            })

            alertController.addAction(check)

            self.present(alertController, animated: true, completion: nil)

        } else {

            self.delegate?.manager(
                self,
                destination: travelDestination,
                duration: travelDuration,
                distance: travelDistance,
                coordinate: [(routePoints["End"]?[0])!, (routePoints["End"]?[1])!]
            )

            dismiss(animated: true, completion: nil)

        }

    }

    @IBAction func popoverCancel(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func publicTransportationButton(_ sender: Any) {

        calculateTravelTime(type: "transit")

    }

    @IBAction func carButton(_ sender: Any) {

        calculateTravelTime(type: "driving")

        carButton.layer.borderWidth = 1
        carButton.layer.borderColor = UIColor.goldfishRed.cgColor
        carButton.tintColor = UIColor.goldfishRed

        walkButton.layer.borderColor = UIColor.clear.cgColor
        walkButton.tintColor = UIColor.darkGray

    }

    @IBAction func walkButton(_ sender: Any) {

        calculateTravelTime(type: "walking")

        walkButton.layer.borderWidth = 1
        walkButton.layer.borderColor = UIColor.goldfishRed.cgColor
        walkButton.tintColor = UIColor.goldfishRed

        carButton.layer.borderColor = UIColor.clear.cgColor
        carButton.tintColor = UIColor.darkGray
    }

    func calculateTravelTime(type: String) {

        if let start0 = routePoints["Start"]?[0], let start1 = routePoints["Start"]?[1], let end0 = routePoints["End"]?[0], let end1 = routePoints["End"]?[1] {

            switch type {
            case "driving", "walking":
                let directionURL = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(start0),\(start1)&destinations=\(end0),\(end1)&mode=\(type)&key=AIzaSyBAu1RqxhTwvzAD-ODP2KmDrpdT8BJwJxA"

                Analytics.logEvent("選擇交通方式", parameters: ["TravelType": type])

                Alamofire.request(directionURL, method: .get, parameters: nil).responseJSON { response in

                    switch response.result {

                    case .success(let data):

                        if let travelData = data as? [String: Any],
                            let route = travelData["rows"] as? [[String: Any]],
                            let detailData = route.first?["elements"] as? [[String: Any]] {

                            if let duration = detailData.first?["duration"] as? [String: Any], let distance = detailData.first?["distance"] as? [String: Any] {

                                if let durationText = duration["text"] as? String, let distanceText = distance["text"] as?String {

                                    //swiftlint:disable force_cast
                                    let desination = self.routeAddresses["Destination"]!
                                    //swiftlint:enable force_cast

                                    self.travelTime.text = "目的地點：\(desination)\r\n總距離：\(distanceText)\r\n總時間：\(durationText)"

                                    self.travelDuration = "\(durationText)"

                                    self.travelDistance = "\(distanceText)"

                                    self.travelDestination = "\(desination)"

                                    let end00 = String(format: "%0.6f", end0)

                                    let end10 = String(format: "%0.6f", end1)

                                    UserDefaults.standard.set(end00, forKey: "destination0")

                                    UserDefaults.standard.set(end10, forKey: "destination1")

                                    UserDefaults.standard.synchronize()

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

        let subView = UIView(frame: CGRect(x: 0, y: 20.0, width: view.frame.width, height: 45.0))

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

        popoverDone.setTitle("確認", for: .normal)
        popoverDone.backgroundColor = UIColor.goldfishRed
        popoverDone.layer.cornerRadius = popoverDone.frame.height/2
        popoverDone.setTitleColor(UIColor.white, for: .normal)
        popoverDone.dropShadow()

        popoverCancel.setTitle("取消", for: .normal)
        popoverCancel.backgroundColor = UIColor.goldfishOrange
        popoverCancel.layer.cornerRadius = popoverCancel.frame.height/2
        popoverCancel.setTitleColor(UIColor.white, for: .normal)
        popoverCancel.dropShadow()

        carButton.tintColor = UIColor.darkGray
        carButton.layer.cornerRadius = carButton.frame.width/2
        carButton.dropShadow()

        walkButton.tintColor = UIColor.darkGray
        walkButton.layer.cornerRadius = walkButton.frame.width/2
        walkButton.dropShadow()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
