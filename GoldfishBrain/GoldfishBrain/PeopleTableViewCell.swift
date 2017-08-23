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

        setupPeopleImage()

        setupPeopleNameLabel()

        setupPeopleChatContent()

        setupDateLabel()
    }

    private func setupPeopleImage() {

        let imageView = peopleImage!

        imageView.layer.masksToBounds = true

        imageView.layer.cornerRadius = imageView.frame.width/2

    }

    private func setupPeopleNameLabel() {

        let label = peopleNameLabel!

        label.font = UIFont(name: "Georgia-Bold", size: 18)

    }

    private func setupPeopleChatContent() {

        let label = peopleChatContentLabel!

        label.font = UIFont(name: "Georgia", size: 18)

    }

    private func setupDateLabel() {

        let label = dateLabel!

        label.font = UIFont(name: "Georgia", size: 16)

        label.textColor = UIColor.lightGray

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
