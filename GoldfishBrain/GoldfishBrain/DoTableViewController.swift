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

    @IBOutlet weak var addDoButton: UIButton!

    @IBOutlet weak var fishImage: UIImageView!

    var doingTravelDatas = [DoingTravelDataMO]()

    let doingCoreDataManager = DoingCoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed

        navigationItem.title = "Do it"

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationController?.navigationBar.tintColor = UIColor.white

        addDoButton.layer.cornerRadius = 15
        addDoButton.layer.borderColor = UIColor(red: 218.0 / 255.0, green: 52.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.6).cgColor
        addDoButton.backgroundColor = UIColor.white
        addDoButton.layer.borderWidth = 1
        addDoButton.setTitle("建立行程", for: .normal)
        addDoButton.setTitleColor(UIColor.goldfishRed, for: .normal)
        addDoButton.dropShadow()

//        fishImage.tintColor = UIColor.black
        fishImage.layer.shadowOffset = CGSize(width: 0, height: 3)
        fishImage.layer.shadowOpacity = 0.4
        fishImage.layer.shadowRadius = 4
        fishImage.layer.shadowColor = UIColor.black.cgColor

        popTableView.estimatedRowHeight = 200.0
        popTableView.rowHeight = UITableViewAutomaticDimension
        popTableView.separatorStyle = UITableViewCellSeparatorStyle.none

    }

    @IBAction func addDoButton(_ sender: Any) {

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
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 60.0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "進行中..."
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return doingTravelDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        if let userDestination = UserDefaults.standard.value(forKey: "destination") as? String, let friendID = UserDefaults.standard.value(forKey: "friend") as? String {

        switch doingTravelDatas.count {
        case 0:

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoneDoCell", for: indexPath) as! NoneDoTableViewCell
            //swiftlint:enable force_cast

            cell.noneLabel.text = "No more task"

            return cell

        default:

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoCell", for: indexPath) as! DoTableViewCell
            //swiftlint:enable force_cast

            //            cell.doDetailsTextView.text = "目的地：\(userDestination)\r\n通知朋友：\(friendID)"

            let travelData = doingTravelDatas[indexPath.row]

            let date = travelData.time!
            let destination = travelData.destination!
            let duration = travelData.duration!
            let friend = travelData.friend!

            cell.doingTravelDataLabel.text = "出發時間：\(date)\r\n目的地：\(destination)\r\n預計行程時間：\(duration)\r\n通知朋友：\(friend)"

            return cell

        }

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            doingCoreDataManager.deleteDoingDo(indexPath: indexPath.row)

            doingCoreDataManager.fetchDoingData()

            self.doingTravelDatas.remove(at: indexPath.row)

            self.popTableView.reloadData()

        }

    }

}
