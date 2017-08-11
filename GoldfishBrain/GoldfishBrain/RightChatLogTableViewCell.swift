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

    override func awakeFromNib() {
        super.awakeFromNib()

        setupRightChatText()

    }

    private func setupRightChatText() {

        let label = rightChatText!

        label.dropShadow()

        label.layer.cornerRadius = 15

        label.layer.backgroundColor = UIColor.goldfishRedLight2.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
