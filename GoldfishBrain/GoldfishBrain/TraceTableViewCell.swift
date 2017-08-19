//
//  TraceTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/10.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class TraceTableViewCell: UITableViewCell {

    @IBOutlet weak var friendDoContent: UILabel!

    @IBOutlet weak var checkButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupFriendDoContent()

//        setupCheckButton()

        setupCancelButton()

    }

    private func setupFriendDoContent() {

    }

//    private func setupCheckButton() {
//
//        let button = checkButton!
//
//        button.setTitle("Check", for: .normal)
//
//        button.backgroundColor = UIColor.goldfishRed
//
//        button.layer.cornerRadius = button.frame.height/2
//
//        button.setTitleColor(UIColor.white, for: .normal)
//
//        button.dropShadow()
//
//    }

    private func setupCancelButton() {

        let button = cancelButton!

        button.setTitle("Cancel", for: .normal)

        button.backgroundColor = UIColor.goldfishOrange

        button.layer.cornerRadius = button.frame.height/2

        button.setTitleColor(UIColor.white, for: .normal)

        button.dropShadow()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
