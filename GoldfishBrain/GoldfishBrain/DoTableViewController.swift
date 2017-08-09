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

    override func viewDidLoad() {
        super.viewDidLoad()

        addDoButton.layer.cornerRadius = 3

        addDoButton.layer.borderColor = UIColor.gray.cgColor

        addDoButton.layer.borderWidth = 1

        addDoButton.setTitle("Add 『 Do 』", for: .normal)

    }

    @IBAction func addDoButton(_ sender: Any) {

        //swiftlint:disable force_cast
        let addDoVC = storyboard?.instantiateViewController(withIdentifier: "addDoVC") as! CreateDoViewController
        //swiftlint:enable force_cast

        present(addDoVC, animated: true, completion: nil)

    }
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated) // No need for semicolon
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
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let userDestination = UserDefaults.standard.value(forKey: "destination") as? String, let friendID = UserDefaults.standard.value(forKey: "friend") as? String {

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoCell", for: indexPath) as! DoTableViewCell
            //swiftlint:enable force_cast

            cell.doDetailsTextView.text = "目的地：\(userDestination)\r\n通知朋友：\(friendID)"

             return cell

        } else {

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoneDoCell", for: indexPath) as! NoneDoTableViewCell
            //swiftlint:enable force_cast

            cell.noneLabel.text = "No more task"

            return cell

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
