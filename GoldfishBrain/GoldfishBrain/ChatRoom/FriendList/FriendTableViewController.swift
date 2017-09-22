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

    let noFriendImageView = UIImageView()

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person]) {

        self.people = people

        if self.people.count == 0 {

            noFriendImageView.isHidden = false

        } else {

            noFriendImageView.isHidden = true

        }

        DispatchQueue.main.async {

            self.friendTableView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetFriend friend: Person) {

        DispatchQueue.main.async {

            self.friendTableView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: String) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed

        navigationItem.title = "Friend List"

        self.navigationController?.navigationBar.tintColor = UIColor.white

        chatRoomManager.delegate = self

        chatRoomManager.fetchFriendIDs()

        friendTableView.separatorStyle = UITableViewCellSeparatorStyle.none

        noFriendImageView.image = UIImage(named: "朋友去背")

        noFriendImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * 0.74)

        view.addSubview(noFriendImageView)

        noFriendImageView.isHidden = true

    }

    override func viewWillAppear(_ animated: Bool) {

        friendTableView.reloadData()

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

}
