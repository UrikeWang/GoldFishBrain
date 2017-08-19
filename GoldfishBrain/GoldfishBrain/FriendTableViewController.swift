//
//  FriendTableViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/29.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import Kingfisher

class FriendTableViewController: UITableViewController, chatRoomManagerDelegate {

    let chatRoomManager = ChatRoomManager()

    var people = [Person]()

    @IBOutlet var friendTableView: UITableView!

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person]) {

        self.people = people

        DispatchQueue.main.async {

            self.friendTableView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetFriend friend: Person) {

        DispatchQueue.main.async {

            self.friendTableView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: Error) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed

        navigationItem.title = "Friend"

        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_person_add.png"), style: .plain, target: self, action: #selector(addFriend))

        chatRoomManager.delegate = self

        chatRoomManager.fetchFriendIDs()

        friendTableView.separatorStyle = UITableViewCellSeparatorStyle.none

    }

    override func viewWillAppear(_ animated: Bool) {

        friendTableView.reloadData()

    }

    func addFriend() {

        //swiftlint:disable force_cast
        let addFriendVC = storyboard?.instantiateViewController(withIdentifier: "addFriendVC") as! AddFriendViewController
        //swiftlint:enable force_cast

        present(addFriendVC, animated: true, completion: nil)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        //swiftlint:enable force_cast

        cell.friendNameLabel.text = people[indexPath.row].firstName

        let url = URL(string: "\(people[indexPath.row].imageUrl)")

//        cell.friendImageView.kf.setImage(with: url)

        cell.friendImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon-placeholder"))

        cell.friendImageView.contentMode = .scaleAspectFill

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowChatLogFromFriend" {

            if let cell = sender as? FriendTableViewCell {

                if let destinationNavigation = segue.destination as? UINavigationController {

                    let destinationViewController = destinationNavigation.viewControllers.first as? ChatLogViewController

                    if let peopleFirstName = cell.friendNameLabel.text {

                        for person in people where peopleFirstName == person.firstName {

                            destinationViewController?.peopleFirstName = person.firstName

                            destinationViewController?.peopleLastName = person.lastName

                            destinationViewController?.peopleID = person.id

                        }

                    }

                }

            }

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
