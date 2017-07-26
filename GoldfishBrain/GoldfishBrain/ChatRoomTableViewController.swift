//
//  ChatRoomTableViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/25.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ChatRoomTableViewController: UITableViewController, chatRoomManagerDelegate {

    let chatRoomManager = ChatRoomManager()

    var people = [Person]()

    @IBOutlet var chatRoomTableView: UITableView!

    @IBAction func logoutButton(_ sender: Any) {

        do {

            try Auth.auth().signOut()

        } catch let logoutError {

            print("登出錯誤:", logoutError)

        }

        UserDefaults.standard.removeObject(forKey: "uid")

        UserDefaults.standard.synchronize()

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterVC")

        self.present(registerVC, animated: true, completion: nil)

    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person]) {

        print("many!!!", people)

        self.people = people

        DispatchQueue.main.async {

            self.chatRoomTableView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: Error) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chatRoomManager.delegate = self

        chatRoomManager.fetchPeople()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleTableViewCell
        //swiftlint:enable force_cast

        cell.peopleNameLabel.text = people[indexPath.row].firstName

        print("count", people.count)

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
