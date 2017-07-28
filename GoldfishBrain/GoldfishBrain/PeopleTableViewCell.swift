//
//  PeopleTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/26.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import Firebase

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var peopleImage: UIImageView!

    @IBOutlet weak var peopleNameLabel: UILabel!

    @IBOutlet weak var peopleChatContentLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setUpPeopleImage() {

//        peopleImage.layer.masksToBounds = true

//        peopleImage.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
