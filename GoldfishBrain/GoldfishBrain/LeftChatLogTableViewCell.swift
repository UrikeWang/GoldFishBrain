//
//  ChatLogTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/27.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class LeftChatLogTableViewCell: UITableViewCell {

    @IBOutlet weak var leftChatText: UILabel!

    @IBOutlet weak var leftChatTimeLabel: UILabel!

    @IBOutlet weak var leftChatView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupLeftChatText()

        setupLeftChatTimeLabel()

        setupLeftChatView()
    }

    private func setupLeftChatView() {

        let view = leftChatView!

        view.dropShadow()

        view.layer.cornerRadius = 6

        view.sizeToFit()

        view.layer.backgroundColor = UIColor.lightGray.cgColor

    }

    private func setupLeftChatText() {

        let label = leftChatText!

//        label.sizeToFit()

    }

    private func setupLeftChatTimeLabel() {

        let label = leftChatTimeLabel!

        label.font = UIFont(name: "Georgia", size: 14)

        label.textColor = UIColor.lightGray

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
