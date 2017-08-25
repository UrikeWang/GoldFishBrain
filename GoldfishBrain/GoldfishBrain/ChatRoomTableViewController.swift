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
import Kingfisher
import SDWebImage

class ChatRoomTableViewController: UITableViewController, chatRoomManagerDelegate, messageManagerDelegate {

    let chatRoomManager = ChatRoomManager()

    var people = [Person]()

    var messages = [Message]()

    var messageManager = MessageManager()

    let noChatImageView = UIImageView()

    @IBOutlet var chatRoomTableView: UITableView!

    @IBOutlet weak var friendListButton: UIBarButtonItem!

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person]) {

        self.people = people

        DispatchQueue.main.async {

            self.chatRoomTableView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetFriend friend: Person) {

    }

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: String) {

    }

    func messageManager(_ manager: MessageManager, didGetMessage message: [Message]) {

        self.messages = message

        if self.messages.count == 0 {

            noChatImageView.isHidden = false

        } else {

            noChatImageView.isHidden = true

        }

        DispatchQueue.main.async {

            self.chatRoomTableView.reloadData()
        }

    }

    func messageManager(_ manager: MessageManager, didGetAllMessage allMessages: [Message]) {

    }

    func messageManager(_ manager: MessageManager, didGetMessagesDict dict: [String: String]) {

    }

    func messageManager(_ manager: MessageManager, didFailWith error: Error) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed

        navigationItem.title = "Chatroom"

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationController?.navigationBar.tintColor = UIColor.white

        chatRoomManager.delegate = self

//        chatRoomManager.fetchPeople()
        chatRoomManager.fetchFriendIDs()

        messageManager.delegate = self

//        messageManager.observeMessages()

        messageManager.observeUserMessages()

        chatRoomTableView.separatorStyle = UITableViewCellSeparatorStyle.none

        noChatImageView.image = UIImage(named: "聊天去背")

        noChatImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * 0.74)

        view.addSubview(noChatImageView)

        noChatImageView.isHidden = true
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
//        return people.count
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleTableViewCell
        //swiftlint:enable force_cast

        let message = messages[indexPath.row]

        if let toID = message.toID as? String {

            let ref = Database.database().reference().child("users").child(toID)

            ref.observeSingleEvent(of: .value, with: { (snapshot) in

                if let dict = snapshot.value as? [String: AnyObject] {

                    cell.peopleNameLabel.text = dict["firstName"] as? String

                    if let profileImageURL = dict["profileImageURL"] as? String {

                        let url = URL(string: "\(profileImageURL)")

//                        cell.peopleImage.kf.setImage(with: url)

                        cell.peopleImage.sd_setImage(with: url, placeholderImage: UIImage(named: "icon-placeholder"))

                        cell.peopleImage.contentMode = .scaleAspectFill

                        cell.peopleImage.layer.masksToBounds = true

                    }
                }

            }, withCancel: nil)

        }

        cell.peopleChatContentLabel.text = message.text

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "hh:mm a" //Specify your format that you want

        dateFormatter.timeZone = TimeZone.current //Set timezone that you want

        let date = Date(timeIntervalSince1970: TimeInterval(message.timestamp))

        let strDate = dateFormatter.string(from: date)

        cell.dateLabel.text = strDate

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowChatLogFromPeople" {

            if let cell = sender as? PeopleTableViewCell {

                if let destinationNavigation = segue.destination as? UINavigationController {

                    let destinationViewController = destinationNavigation.viewControllers.first as? ChatLogViewController

                    if let peopleFirstName = cell.peopleNameLabel.text {

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
