//
//  AddFriendViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/19.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {

    @IBOutlet weak var addFriendEmailLabel: UILabel!

    @IBOutlet weak var addFriendEmailTextField: UITextField!

    @IBOutlet weak var searchFriendButton: UIButton!

    @IBOutlet weak var checkFriendLabel: UILabel!

    @IBOutlet weak var friendNameLabel: UILabel!

    @IBOutlet weak var addFriendButton: UIButton!

    @IBOutlet weak var cancelAddFriendButton: UIButton!

    @IBAction func searchFriendButton(_ sender: Any) {
    }

    @IBAction func addFriendButton(_ sender: Any) {
    }

    @IBAction func cancelAddFriendButton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        cancelAddFriendButton.setTitle("取消新增", for: .normal)
        cancelAddFriendButton.backgroundColor = UIColor.goldfishOrange
        cancelAddFriendButton.layer.cornerRadius = cancelAddFriendButton.frame.height/2
        cancelAddFriendButton.setTitleColor(UIColor.white, for: .normal)
        cancelAddFriendButton.dropShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
