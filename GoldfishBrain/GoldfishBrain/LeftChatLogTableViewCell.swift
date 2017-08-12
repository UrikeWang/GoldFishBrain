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

    override func awakeFromNib() {
        super.awakeFromNib()

        setupLeftChatText()
    }

    private func setupLeftChatText() {

        let label = leftChatText!

        label.dropShadow()

        label.layer.cornerRadius = 15

        label.layer.backgroundColor = UIColor.lightGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
