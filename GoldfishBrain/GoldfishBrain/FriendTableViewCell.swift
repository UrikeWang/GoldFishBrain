//
//  FriendTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/29.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImageView: UIImageView!

    @IBOutlet weak var friendNameLabel: UILabel!

    @IBOutlet weak var friendContentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
