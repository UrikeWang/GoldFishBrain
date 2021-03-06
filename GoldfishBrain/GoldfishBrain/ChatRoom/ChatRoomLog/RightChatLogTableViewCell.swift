//
//  RightChatLogTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/3.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class RightChatLogTableViewCell: UITableViewCell {

    @IBOutlet weak var rightChatText: UILabel!

    @IBOutlet weak var rightChatTimeLabel: UILabel!

    @IBOutlet weak var rightChatView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupRightChatText()

        setupRightChatTimeLabel()

        setupRightChatView()

    }

    private func setupRightChatView() {

        let view = rightChatView!

//        view.dropShadow()

        view.layer.cornerRadius = 6

        view.layer.borderColor = UIColor.goldfishRed.cgColor

        view.layer.borderWidth = 1

    }

    private func setupRightChatText() {

        _ = rightChatText!

//        label.sizeToFit()

//        label.dropShadow()
//
//        label.layer.cornerRadius = 6
//
//        label.layer.backgroundColor = UIColor.goldfishRedLight2.cgColor

    }

    private func setupRightChatTimeLabel() {

        let label = rightChatTimeLabel!

        label.font = UIFont(name: "Georgia", size: 14)

        label.textColor = UIColor.lightGray

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
