//
//  DoTableViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/2.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class DoTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, CollapsibleTableViewHeaderDelegate {

    @IBOutlet var popTableView: UITableView!

    var doingTravelDatas = [DoingTravelDataMO]()

    let doingCoreDataManager = DoingCoreDataManager()

    var sectionList = ["使用方式", "行程進行中"]

    var sectionsCollapsed = [false, false] //false為全展開

    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {

        let collapsed = !sectionsCollapsed[section]

        sectionsCollapsed[section] = collapsed

        header.setCollapsed(collapsed)

        popTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed

        navigationItem.title = "My Trip"

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_person_add.png"), style: .plain, target: self, action: #selector(addFriend))

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

    func addFriend() {

        //swiftlint:disable force_cast
        let addFriendVC = storyboard?.instantiateViewController(withIdentifier: "addFriendVC") as! AddFriendViewController
        //swiftlint:enable force_cast

        present(addFriendVC, animated: true, completion: nil)

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

        return 2
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 44.0

    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 1.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")

        header.titleLabel.text = sectionList[section]

        header.arrowLabel.text = ">"

        header.setCollapsed(sectionsCollapsed[section])

        header.section = section

        header.delegate = self

        return header

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case 0:

            return sectionsCollapsed[section] ? 0 : 1

        case 1:

            return sectionsCollapsed[section] ? 0 : doingTravelDatas.count

        default:

            return 0
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension

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

            let travelData = doingTravelDatas[indexPath.row]

            let date = travelData.time!
            let destination = travelData.destination!
            let duration = travelData.duration!
            let friend = travelData.friend!

            cell.doingTravelDate.text = date
            cell.doingTravelDestination.text = destination
            cell.doingToFriend.text = friend
            cell.doingTravelDuration.text = duration

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

            let creatDoViewController = CreateDoViewController()

            creatDoViewController.autoSendDo(text: "我取消前往 \(doingTravelDatas[0].destination!) 的行程了", id: doingTravelDatas[0].friendID!)

            doingCoreDataManager.deleteDoingDo(indexPath: indexPath.row)

            self.doingTravelDatas.remove(at: indexPath.row)

            doingTravelDatas = []

            self.popTableView.reloadData()

        }

    }

}
