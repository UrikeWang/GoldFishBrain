//
//  ProfileTableViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/26.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher
import CoreData
import GoogleMaps
import GooglePlaces

class ProfileTableViewController: UITableViewController, profileManagerDelegate/*, managerCreateStartDelegate*/ {

    @IBOutlet weak var firstNameLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet var dosTableView: UITableView!

    @IBOutlet weak var separateLine: UIView!

    var profiles: [Profile] = []

    let profileManager = ProfileManager()

    var userFirstName = ""

    var userLastName = ""

    var doDestination = ""

    var doDuration = ""

    var doDistance = ""

    var doCoordinate = [Double]()

    var travelDatas = [TravelDataMO]()

    @IBOutlet weak var mapView: GMSMapView!

    let addPopViewController = AddDoPopViewController()

    var locationManager = CLLocationManager()

    var placesClient: GMSPlacesClient!

    let coreDataManager = CoreDataManager()

//    //swiftlint:disable force_cast
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    //swiftlint:enable force_cast

    var isNotified = false

    func profileManager(_ manager: ProfileManager, didGetProfile profile: [Profile]) {

        self.profiles = profile

        self.userFirstName = profiles[0].firstName

        self.userLastName = profiles[0].lastName

        self.firstNameLabel.text = "   \(userFirstName)"

        // TODO : 是否要將user first / last name 存到userdefaults

    }

    func profileManager(_ manager: ProfileManager, didFailWith error: Error) {

    }

    func profileManager(_ manager: ProfileManager, didGetImage url: String) {

        let imageUrl = URL(string: "\(url)")

//        profileImage.kf.setImage(with: imageUrl)

        profileImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "icon-placeholder"))

//        profileImage.downloadedFrom(link: url, contentMode: .scaleAspectFill)

        profileImage.layer.masksToBounds = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationController?.navigationBar.tintColor = UIColor.white

        navigationItem.title = "Profile"

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        locationManager.allowsBackgroundLocationUpdates = true

        //設定需要重新定位的距離差距
        locationManager.distanceFilter = 10

        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        //Initialize the GMSPlacesClient
        placesClient = GMSPlacesClient.shared()

        //取得user註冊時的first/last name 為async
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            profileManager.delegate = self

            profileManager.fetchProfile(uid: uid)

            profileManager.fetchProfileImage(uid: uid)

        }

        //changed / set profile image (點擊圖片)
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectionProfileImage)))
        profileImage.isUserInteractionEnabled = true

        firstNameLabel.textAlignment = .left
        firstNameLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7)

        dosTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon

        fetchTravelDetails()

    }

    func fetchTravelDetails() {

        travelDatas = coreDataManager.fetchData()

        self.dosTableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "歷史行程"
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 60.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return travelDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMyDosCell", for: indexPath) as! AllMyDosTableViewCell
        //swiftlint:enable force_cast

        if let date = travelDatas[indexPath.row].time {

            cell.travelDate.text = "出發時間：" + date

        } else {

            cell.travelDate.text = "出發時間："
        }

        if let destination = travelDatas[indexPath.row].destination {

            cell.travelDestination.text = "目的地：" + destination

        } else {

            cell.travelDestination.text = "目的地："
        }

        if let finished = travelDatas[indexPath.row].finished as? Bool {

            cell.travelFinished.text = "行程是否完成：\(finished)"

        } else {

            cell.travelFinished.text = "行程是否完成："
        }

        if let notified = travelDatas[indexPath.row].notify as? Bool {

            cell.travelNotified.text = "行程是否通知：\(notified)"

        } else {

            cell.travelNotified.text = "行程是否通知："
        }

        cell.travelDestination.tag = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            coreDataManager.deleteDo(indexPath: indexPath.row)

            coreDataManager.fetchData()

            self.travelDatas.remove(at: indexPath.row)

            self.dosTableView.reloadData()

        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
