//
//  CreateDoViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/3.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import CoreData
import Firebase

protocol managerCreateStartDelegate: class {

    func manager(_ manager: CreateDoViewController, didGestDestinationCoordinate coordinate: [Double])
}

class CreateDoViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, managerDestinationDelegate, managerFriendDelegate {

    @IBOutlet weak var dateText: UITextField!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var destinationLabel: UILabel!

    @IBOutlet weak var toWhoLabel: UILabel!

    @IBOutlet var popMapView: UIView!

    @IBOutlet weak var createDoButton: UIButton!

    @IBOutlet weak var cancelDoButton: UIButton!

    @IBOutlet weak var destinationText: UITextField!

    @IBOutlet weak var friendText: UITextField!

    @IBOutlet weak var detailsLabel: UILabel!

    var effect: UIVisualEffect!

    let dateTimeFormatter = DateFormatter()

    var travelDuration = ""

    var travelDistance = ""

    var travelDestination = ""

    var travelTime = ""

    var friendName = ""

    var friendID = ""

    var coordinate = [Double]()

    //swiftlint:disable force_cast
    let uid = UserDefaults.standard.value(forKey: "uid") as! String
    //swiftlint:enable force_cast

    let profileViewController = ProfileTableViewController()

    weak var delegate: managerCreateStartDelegate?

    @IBOutlet weak var travelDetails: UITextView!

    @IBAction func dateText(_ sender: UITextField) {

        let datePicker: UIDatePicker = UIDatePicker()

        // 設置 UIDatePicker 格式
        datePicker.datePickerMode = .dateAndTime

        // 選取時間時的分鐘間隔 這邊以 5 分鐘為一個間隔
        datePicker.minuteInterval = 1
        datePicker.date = Date()

        //中文化
        datePicker.locale = Locale(identifier: "zh_TW")

        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        // Adds the buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateDoViewController.donePressed))

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateDoViewController.cancelClick))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        toolBar.isUserInteractionEnabled = true

        sender.inputView = datePicker

        sender.inputAccessoryView = toolBar

        datePicker.addTarget(self, action: #selector(CreateDoViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }

    @IBAction func destinationText(_ sender: Any) {

        //swiftlint:disable force_cast
        let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as! AddDoPopViewController
        //swiftlint:enable force_cast

        popVC.modalPresentationStyle = .fullScreen

        popVC.delegate = self

        if let popOverVC = popVC.popoverPresentationController {

            //swiftlint:disable force_cast
            let viewForSource = sender as! UITextField
            //swiftlint:enable force_cast

            popOverVC.sourceView = viewForSource

            popOverVC.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

//            popVC.preferredContentSize = CGSize(width: 350, height: 600)

            popOverVC.delegate = self

            /*//把原本按鈕隱藏
            viewForSource.alpha = 0.0
            viewForSource.layer.cornerRadius = 5
            viewForSource.layer.borderWidth = 2
            */
        }

        self.present(popVC, animated: true, completion: nil)

    }

    @IBAction func toWhoText(_ sender: Any) {

        //swiftlint:disable force_cast
        let popFriendVC = storyboard?.instantiateViewController(withIdentifier: "popFriendVC") as! PopFriendViewController
        //swiftlint:enable force_cast

        popFriendVC.modalPresentationStyle = .fullScreen

        popFriendVC.delegate = self

        if let popOverFriendVC = popFriendVC.popoverPresentationController {

            //swiftlint:disable force_cast
            let viewForSource = sender as! UITextField
            //swiftlint:enable force_cast

            popOverFriendVC.sourceView = viewForSource

//            popOverFriendVC.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
//
//            popFriendVC.preferredContentSize = CGSize(width: 350, height: 300)

            popOverFriendVC.delegate = self

        }

        self.present(popFriendVC, animated: true, completion: nil)
    }

    func manager(_ manager: AddDoPopViewController, destination: String, duration: String, distance: String, coordinate: [Double]) {

        self.travelDistance = distance

        self.travelDuration = duration

        self.travelDestination = destination

        self.coordinate = coordinate

        destinationText.text = destination

        travelDetails.text = "出發時間：\(travelTime)\n\r目的地：\(self.travelDestination)\n\r行程時間：\(self.travelDuration)\n\r通知：\(self.friendName)"

        self.view.reloadInputViews()
    }

    func manager(_ manager: PopFriendViewController, name: String, id: String) {

        self.friendName = name

        self.friendID = id

        friendText.text = name

        travelDetails.text = "出發時間：\(travelTime)\n\r目的地：\(self.travelDestination)\n\r行程時間：\(self.travelDuration)\n\r通知：\(self.friendName)"

    }

    //Picker Date Done Button
    func donePressed(_ sender: UIBarButtonItem) {

        dateText.resignFirstResponder()

    }

    func datePickerValueChanged(_ sender: UIDatePicker) {

        let dateFormatter1 = DateFormatter()

        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm"

        dateText.text = dateFormatter1.string(from: sender.date)

        travelTime = dateText.text!

    }

    func cancelClick() {

        dateText.resignFirstResponder()
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {

        return .none

    }

    @IBAction func createDoButton(_ sender: Any) {

        if travelDestination != "" && friendID != "" {

            //自動傳message
            autoSendDo(text: travelDetails.text, id: friendID)

            //將目的地加到region並開始追蹤
//            profileViewController.checkUserCurrentDestination(coordinate: coordinate)

            profileViewController.startMonitoring()

            destinationCoordinates = coordinate

            isNotified = [0]

            let doingCoreDataManager = DoingCoreDataManager()

            let doingTravelDatas = doingCoreDataManager.fetchDoingData()

            let doingCount = doingTravelDatas.count

            if doingCount == 0 {

                //加到doingCoreManager
                doingCoreDataManager.addDoingDo(time: travelTime, destination: travelDestination, distance: travelDistance, duration: travelDuration, friend: friendName)

            } else {

                //先刪除原本的目的地資訊
//                doingCoreDataManager.deleteDoingDo(indexPath: 0)

                //加到doingCoreManager
                doingCoreDataManager.addDoingDo(time: travelTime, destination: travelDestination, distance: travelDistance, duration: travelDuration, friend: friendName)

                //將對方firebase原本的事件刪除
                let eventID = Database.database().reference().child("users").child(uid)//.child("eventID")

                eventID.observeSingleEvent(of: .value, with: { (snapshot) in

                    let value = snapshot.value as? NSDictionary

                    let eventID = value?["eventID"] as? String ?? ""

                    self.deleteEvent(eventID: eventID)

                })

             }

            //存到firebase對方的事件中，讓對方手機中的trace能夠知道
            createEvent(time: travelTime, destination: travelDestination, duration: travelDuration, toFriend: friendID, fromFriend: uid)

            //存到userdefault中，當使用者到達目的地時，會自動傳message到對方的手機中
            UserDefaults.standard.set(travelDestination, forKey: "destination")
            UserDefaults.standard.set(friendName, forKey: "friend")
            UserDefaults.standard.set(friendID, forKey: "friendID")
            UserDefaults.standard.synchronize()

            self.dismiss(animated: false, completion: nil)

        } else {

            print("You did not set your destination or friend you want to notify.")

        }

    }

    @IBAction func cancelDoButton(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        tabBarC = self.tabBarController as? TabBarController

        let date = Date()

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        let dateString = dateFormatter.string(from: date)

        dateText.text = dateString
//        dateText.placeholder = "Select time.."

        destinationText.placeholder = "Select destination"

        friendText.placeholder = "Select friend"

        //textFieldDidBeginEditing
        self.dateText.delegate = self

        dateLabel.text = "    選擇您的出發時間"
        dateLabel.backgroundColor = UIColor.goldfishRedLight
        dateLabel.textColor = UIColor.white

        destinationLabel.text = "    選擇您的目的地"
        destinationLabel.backgroundColor = UIColor.goldfishRedLight
        destinationLabel.textColor = UIColor.white

        toWhoLabel.text = "    選擇您要通知的朋友"
        toWhoLabel.backgroundColor = UIColor.goldfishRedLight
        toWhoLabel.textColor = UIColor.white

        detailsLabel.text = "    行程資訊"
        detailsLabel.backgroundColor = UIColor.goldfishOrangeLight
        detailsLabel.textColor = UIColor.white

        createDoButton.setTitle("新增", for: .normal)
        createDoButton.backgroundColor = UIColor.goldfishRed
        createDoButton.layer.cornerRadius = createDoButton.frame.height/2
        createDoButton.setTitleColor(UIColor.white, for: .normal)
        createDoButton.dropShadow()

        cancelDoButton.setTitle("取消", for: .normal)
        cancelDoButton.backgroundColor = UIColor.goldfishOrange
        cancelDoButton.layer.cornerRadius = cancelDoButton.frame.height/2
        cancelDoButton.setTitleColor(UIColor.white, for: .normal)
        cancelDoButton.dropShadow()

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated) // No need for semicolon

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createEvent(time: String, destination: String, duration: String, toFriend: String, fromFriend: String) {

        let eventRef = Database.database().reference().child("events").child(toFriend).childByAutoId()

        let eventID = eventRef.key

//        UserDefaults.standard.set(eventID, forKey: "eventID")
//        
//        UserDefaults.standard.synchronize()

        eventRef.observeSingleEvent(of: .value, with: { (_) in

                let values = ["time": time, "destination": destination, "duration": duration, "fromFriend": fromFriend]

                eventRef.updateChildValues(values)

        })

        let userRef = Database.database().reference().child("users").child(uid)

        let eventValue = ["eventID": eventID]

        userRef.updateChildValues(eventValue)

    }

    func deleteEvent(eventID: String) {

            let eventRef = Database.database().reference().child("events")

            eventRef.observe(.value, with: { (dataSnapshot) in

                for snapshotChild in dataSnapshot.children {

                    guard let eventSource = snapshotChild as? DataSnapshot else { return }

                    if let userDict = eventSource.value as? [String: AnyObject] {

                        for event in userDict {

                            if event.key == eventID {

                                eventRef.child(eventSource.key).child(eventID).removeValue()
                            }

                        }

                    }

                }

            })

    }

    func autoSendDo(text: String, id: String) {

        var istalked = false

        var isrun = Int()

        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {

            let timestamp = Int(Date().timeIntervalSince1970)

            let channelRef = Database.database().reference().child("channels")
            //            let childRef = ref.childByAutoId()

            let childTalkRef = channelRef.childByAutoId()

            let chatsRef = Database.database().reference().child("users").child(uid).child("chats")

            let chatsToRef =  Database.database().reference().child("users").child(friendID).child("chats")

            let childTalkTextID = childTalkRef.childByAutoId()

            chatsRef.observeSingleEvent(of: .value, with: { (snapshot) in

                switch snapshot.childrenCount {

                case 0 :

                    let memValues = ["0": uid, "1": self.friendID]

                    let values = ["text": text, "fromID": uid, "toID": self.friendID, "timestamp": timestamp] as [String : Any]

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

                                    if (uid == chatMember1 && self.friendID == chatMember2) || (uid == chatMember2 && self.friendID == chatMember1) {

                                        istalked = true

                                        let values = ["text": text, "fromID": uid, "toID": self.friendID, "timestamp": timestamp] as [String : Any]

                                        channelRef.child(chatroomID).childByAutoId().updateChildValues(values)

                                    }

                                    isrun -= 1

                                }

                                if istalked == false && isrun == 0 {

                                    let memValues = ["0": uid, "1": self.friendID]

                                    let values = ["text": text, "fromID": uid, "toID": self.friendID, "timestamp": timestamp] as [String : Any]

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
