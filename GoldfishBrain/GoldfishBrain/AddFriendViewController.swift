//
//  AddFriendViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/19.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, chatRoomManagerDelegate {

    @IBOutlet weak var addFriendEmailLabel: UILabel!

    @IBOutlet weak var addFriendEmailTextField: UITextField!

    @IBOutlet weak var searchFriendButton: UIButton!

    @IBOutlet weak var checkFriendLabel: UILabel!

    @IBOutlet weak var friendNameLabel: UILabel!

    @IBOutlet weak var addFriendButton: UIButton!

    @IBOutlet weak var cancelAddFriendButton: UIButton!

    let chatRoomManager = ChatRoomManager()

    var friend: Person?

    @IBAction func searchFriendButton(_ sender: Any) {

        guard let friendEmail = addFriendEmailTextField.text
            else {

                let alertController = UIAlertController(
                    title: "溫馨小提醒",
                    message: "使用者不存在",
                    preferredStyle: .alert)

                let check = UIAlertAction(title: "OK", style: .default, handler: { (_ : UIAlertAction) in
                    alertController.dismiss(animated: true, completion: nil)
                })

                alertController.addAction(check)

                self.present(alertController, animated: true, completion: nil)

                return
        }

        chatRoomManager.searchFriend(email: friendEmail)

    }

    @IBAction func addFriendButton(_ sender: Any) {

        chatRoomManager.addFriend(friend: friend!)

        dismiss(animated: true, completion: nil)

    }

    @IBAction func cancelAddFriendButton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person]) {

    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetFriend friend: Person) {

        self.friend = friend

        friendNameLabel.text = self.friend?.firstName

    }

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: Error) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chatRoomManager.delegate = self

        addFriendEmailLabel.text = "Enter your friend's email"
        addFriendEmailLabel.backgroundColor = UIColor.goldfishRedLight
        addFriendEmailLabel.textColor = UIColor.white

        searchFriendButton.setTitle("搜尋朋友", for: .normal)
        searchFriendButton.backgroundColor = UIColor.asiSeaBlue
        searchFriendButton.layer.cornerRadius = addFriendButton.frame.height/2
        searchFriendButton.setTitleColor(UIColor.white, for: .normal)
        searchFriendButton.dropShadow()

        checkFriendLabel.text = "Check your friend's name"
        checkFriendLabel.backgroundColor = UIColor.goldfishOrangeLight
        checkFriendLabel.textColor = UIColor.white

        addFriendButton.setTitle("新增朋友", for: .normal)
        addFriendButton.backgroundColor = UIColor.goldfishRed
        addFriendButton.layer.cornerRadius = addFriendButton.frame.height/2
        addFriendButton.setTitleColor(UIColor.white, for: .normal)
        addFriendButton.dropShadow()

        cancelAddFriendButton.setTitle("取消此次新增", for: .normal)
        cancelAddFriendButton.backgroundColor = UIColor.goldfishOrange
        cancelAddFriendButton.layer.cornerRadius = cancelAddFriendButton.frame.height/2
        cancelAddFriendButton.setTitleColor(UIColor.white, for: .normal)
        cancelAddFriendButton.dropShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
