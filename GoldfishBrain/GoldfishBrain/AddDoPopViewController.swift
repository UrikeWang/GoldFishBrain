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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the location manager
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.distanceFilter = 50
        
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = self
        
        //Initialize the GMSPlacesClient
        placesClient = GMSPlacesClient.shared()

//        view.layer.shadowOffset = CGSize(width: -1, height: 1)
//
//        view.layer.shadowColor = UIColor.black.cgColor

        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)

        self.mapView.isMyLocationEnabled = true

        self.mapView.camera = camera

//        mapView.isMyLocationEnabled = true
//        view = mapView

        // Creates a marker in the center of the map.
        let marker = GMSMarker()

        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)

        marker.title = "Sydney"

        marker.snippet = "Australia"

        //swiftlint:disable force_cast
        marker.map = mapView

        // Do any additional setup after loading the view.

//        self.view.addSubview(mapView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
