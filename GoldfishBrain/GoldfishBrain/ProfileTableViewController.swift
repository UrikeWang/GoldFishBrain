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

class ProfileTableViewController: UITableViewController, profileManagerDelegate {

    @IBOutlet weak var firstNameLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet var dosTableView: UITableView!

    var profiles: [Profile] = []

    let profileManager = ProfileManager()

    var userFirstName = ""

    var userLastName = ""

    var travelDatas = [TravelDataMO]()

    var travelData: TravelDataMO!

    //swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //swiftlint:enable force_cast

    func profileManager(_ manager: ProfileManager, didGetProfile profile: [Profile]) {

        self.profiles = profile

        self.userFirstName = profiles[0].firstName

        self.userLastName = profiles[0].lastName

        self.firstNameLabel.text = userFirstName

        // TODO : 是否要將user first / last name 存到userdefaults

    }

    func profileManager(_ manager: ProfileManager, didFailWith error: Error) {

    }

    func profileManager(_ manager: ProfileManager, didGetImage url: String) {

        let imageUrl = URL(string: "\(url)")

        profileImage.kf.setImage(with: imageUrl)

//        profileImage.downloadedFrom(link: url, contentMode: .scaleAspectFill)

        profileImage.layer.masksToBounds = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //取得user註冊時的first/last name 為async
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            profileManager.delegate = self

            profileManager.fetchProfile(uid: uid)

            profileManager.fetchProfileImage(uid: uid)

        }

        //changed / set profile image (點擊圖片)
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectionProfileImage)))

        profileImage.isUserInteractionEnabled = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let request: NSFetchRequest<TravelDataMO> = TravelDataMO.fetchRequest()
            do {

                travelDatas = try context.fetch(request)

            } catch {

                print(error)

            }

            dosTableView.reloadData()

        }

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return travelDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMyDosCell", for: indexPath) as! AllMyDosTableViewCell
        //swiftlint:enable force_cast

        if let date = travelDatas[indexPath.row].time as? String {

            cell.travelDate.text = "出發時間：" + date

        } else {

            cell.travelDate.text = "出發時間："
        }

        if let destination = travelDatas[indexPath.row].destination as? String {

            cell.travelDestinationTextView.text = "目的地：" + destination

        } else {

            cell.travelDestinationTextView.text = "目的地："
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

//        cell.travelDate.text = "出發時間：\(travelDatas[indexPath.row].time)"

        //swiftlint:disable force_cast
//        cell.travelDestinationTextView.text = "目的地：\(travelDatas[indexPath.row].destination!)"
//        //swiftlint:enable force_cast
//        
//        cell.travelFinished.text = "行程是否完成：\(travelDatas[indexPath.row].finished)"
//        
//        cell.travelNotified.text = "行程是否通知：\(travelDatas[indexPath.row].notify)"

        return cell
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
