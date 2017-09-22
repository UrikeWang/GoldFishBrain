//
//  TraceTableViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/10.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import Firebase

class TraceTableViewController: UITableViewController, traceManagerDelegete {

    let traceManager = TraceManager()

    var events = [Event]()

    @IBOutlet var friendEventTableView: UITableView!

//    @IBAction func checkButton(_ sender: UIButton) {
//    }

    let noEventImageView = UIImageView()

    @IBAction func cancelButton(_ sender: UIButton) {

        let deleteEventID = events[sender.tag].eventID

        let fromFriendID = events[sender.tag].fromFriendID

        let friendDestination = events[sender.tag].destination

        let alertController = UIAlertController(
            title: "溫馨小提醒",
            message: "真的要刪除朋友的行程嗎？",
            preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default, handler: { (_ : UIAlertAction) in

            self.autoSendDelete(destination: friendDestination, id: fromFriendID)

            self.traceManager.deleteFriendEvent(deleteEventID: deleteEventID)

            DispatchQueue.main.async {

                self.friendEventTableView.reloadData()
            }

            alertController.dismiss(animated: true, completion: nil)
        })

        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_ : UIAlertAction) in

            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(ok)

        alertController.addAction(cancel)

        self.present(alertController, animated: true, completion: nil)

    }

    func traceManager(_ manager: TraceManager, didGetEvent events: [Event]) {

        self.events = events

        if self.events.count == 0 {

            noEventImageView.isHidden = false

        } else {

            noEventImageView.isHidden = true

        }

        DispatchQueue.main.async {

            self.friendEventTableView.reloadData()

        }

    }

    func traceManager(_ manager: TraceManager, didFailWith error: Error) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.goldfishRed

        navigationItem.title = "Friend's Trip"

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationController?.navigationBar.tintColor = UIColor.white

        traceManager.delegate = self

        traceManager.fetchFriendEvents()

        friendEventTableView.rowHeight = UITableViewAutomaticDimension
        friendEventTableView.estimatedRowHeight = 60

        friendEventTableView.separatorColor = UIColor.goldfishRed
        friendEventTableView.separatorInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        friendEventTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        noEventImageView.image = UIImage(named: "朋友行程去背")

        noEventImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * 0.74)

        view.addSubview(noEventImageView)

        noEventImageView.isHidden = true

    }

    override func viewWillAppear(_ animated: Bool) {

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

        if events.count == 0 {

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoneEventCell", for: indexPath) as! NoneEventTableViewCell

            return cell

        } else {

            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "TraceCell", for: indexPath) as! TraceTableViewCell

            let event = events[indexPath.row]

            cell.cancelButton.tag = indexPath.row

            cell.friendName.text = event.fromFriend

            cell.friendDoDate.text = event.time

            cell.friendDoDestination.text = event.destination

            cell.friendDoDuration.text = event.duration

            return cell

        }

    }

    func autoSendDelete(destination: String, id: String) {

        var istalked = false

        var isrun = Int()

        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            let timestamp = Int(Date().timeIntervalSince1970)

            let channelRef = Database.database().reference().child("channels")

            let childTalkRef = channelRef.childByAutoId()

            let chatsRef = Database.database().reference().child("users").child(uid).child("chats")

            let chatsToRef =  Database.database().reference().child("users").child(id).child("chats")

            let childTalkTextID = childTalkRef.childByAutoId()

            chatsRef.observeSingleEvent(of: .value, with: { (snapshot) in

                switch snapshot.childrenCount {

                case 0 :

                    let memValues = ["0": uid, "1": id]

                    let values = ["text": "我刪除追蹤 \(destination) 行程拉！！！", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                    childTalkRef.child("members").updateChildValues(memValues)

                    childTalkTextID.updateChildValues(values)

                    chatsRef.updateChildValues([childTalkRef.key: 1])

                    chatsToRef.updateChildValues([childTalkRef.key: 1])

                case _ where snapshot.childrenCount > 0 :

                    isrun = Int(snapshot.childrenCount)

                    for chat in (snapshot.value as? [String: Any])! {

                        //channels ID
                        if let chatroomID = chat.key as? String {

                            channelRef.observeSingleEvent(of:.value, with: { (dataSnapshot) in

                                if let member = dataSnapshot.childSnapshot(forPath: chatroomID).childSnapshot(forPath: "members").value as? [String] {

                                    let chatMember1 = member[0]

                                    let chatMember2 = member[1]

                                    if (uid == chatMember1 && id == chatMember2) || (uid == chatMember2 && id == chatMember1) {

                                        istalked = true

                                        let values = ["text": "我刪除追蹤 \(destination) 行程拉！！！", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                                        channelRef.child(chatroomID).childByAutoId().updateChildValues(values)

                                    }

                                    isrun -= 1

                                }

                                if istalked == false && isrun == 0 {

                                    let memValues = ["0": uid, "1": id]

                                    let values = ["text": "我刪除追蹤 \(destination) 行程拉！！！", "fromID": uid, "toID": id, "timestamp": timestamp] as [String : Any]

                                    childTalkRef.child("members").updateChildValues(memValues)

                                    childTalkTextID.updateChildValues(values)

                                    chatsRef.updateChildValues([childTalkRef.key: 1])

                                    chatsToRef.updateChildValues([childTalkRef.key: 1])

                                    istalked = true

                                }

                            }, withCancel: nil)

                        }

                    }

                default: break

                }

            }, withCancel: nil)

        }

    }

}
