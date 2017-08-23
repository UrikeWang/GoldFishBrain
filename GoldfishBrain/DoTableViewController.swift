//
//  DoTableViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/2.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class DoTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet var popTableView: UITableView!

    var doingTravelDatas = [DoingTravelDataMO]()

    let doingCoreDataManager = DoingCoreDataManager()

    var sectionList = ["使用方式", "行程進行中"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed

        navigationItem.title = "My Trip"

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationController?.navigationBar.tintColor = UIColor.white

        popTableView.estimatedRowHeight = 200.0
        popTableView.rowHeight = UITableViewAutomaticDimension
        popTableView.separatorStyle = UITableViewCellSeparatorStyle.none

    }

    @IBAction func addTripButton(_ sender: Any) {

        //swiftlint:disable force_cast
        let addDoVC = storyboard?.instantiateViewController(withIdentifier: "addDoVC") as! CreateDoViewController
        //swiftlint:enable force_cast

        present(addDoVC, animated: true, completion: nil)

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated) // No need for semicolon

        fetchDoingTravelDetails()

    }

    func fetchDoingTravelDetails() {

        doingTravelDatas = doingCoreDataManager.fetchDoingData()

        DispatchQueue.main.async {

            self.popTableView.reloadData()

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 60.0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return sectionList[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return doingTravelDatas.count

        switch section {
        case 0:

            return 1

        case 1:

            return doingTravelDatas.count

        default:

            return 0
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoneDoCell", for: indexPath) as! NoneDoTableViewCell
            //swiftlint:enable force_cast

            return cell

        } else {

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoCell", for: indexPath) as! DoTableViewCell
            //swiftlint:enable force_cast

            //            cell.doDetailsTextView.text = "目的地：\(userDestination)\r\n通知朋友：\(friendID)"

            let travelData = doingTravelDatas[indexPath.row]

            let date = travelData.time!
            let destination = travelData.destination!
            let duration = travelData.duration!
            let friend = travelData.friend!

            cell.doingTravelDate.text = date
            cell.doingTravelDestination.text = destination
            cell.doingToFriend.text = friend
            cell.doingTravelDuration.text = duration

            //            cell.doingTravelDataLabel.text = "出發時間：\(date)\r\n目的地點：\(destination)\r\n通知朋友：\(friend)\r\n預計行程時間：\(duration)"

            return cell

        }

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        if indexPath.section == 0 {

            return false

        } else {

            return true

        }

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            doingCoreDataManager.deleteDoingDo(indexPath: indexPath.row)

            doingCoreDataManager.fetchDoingData()

            self.doingTravelDatas.remove(at: indexPath.row)

            doingTravelDatas = []

            self.popTableView.reloadData()

        }

    }

}
