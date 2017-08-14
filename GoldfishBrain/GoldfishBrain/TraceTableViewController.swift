//
//  TraceTableViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/10.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class TraceTableViewController: UITableViewController, traceManagerDelegete {

    let traceManager = TraceManager()

    var events = [Event]()

    @IBOutlet var friendEventTableView: UITableView!

    @IBAction func checkButton(_ sender: UIButton) {
    }

    @IBAction func cancelButton(_ sender: UIButton) {

        let deleteEventID = events[sender.tag].eventID

        traceManager.deleteFriendEvent(deleteEventID: deleteEventID)

        DispatchQueue.main.async {

            self.friendEventTableView.reloadData()
        }

    }

    func traceManager(_ manager: TraceManager, didGetEvent events: [Event]) {

        self.events = events

        DispatchQueue.main.async {

            self.friendEventTableView.reloadData()

        }

    }

    func traceManager(_ manager: TraceManager, didFailWith error: Error) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed

        navigationItem.title = "Trace"

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationController?.navigationBar.tintColor = UIColor.white

        traceManager.delegate = self

        traceManager.fetchFriendEvents()

        friendEventTableView.rowHeight = UITableViewAutomaticDimension
        friendEventTableView.estimatedRowHeight = 60

    }

    override func viewWillAppear(_ animated: Bool) {

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

        return events.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "TraceCell", for: indexPath) as! TraceTableViewCell

        let event = events[indexPath.row]

        cell.cancelButton.tag = indexPath.row

        cell.checkButton.tag = indexPath.row

        cell.friendDoContent.text = "\(event.fromFriend)\r出發時間：\(event.time)\r目的地：\(event.destination)\r預估時間：\(event.duration)\r"

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
