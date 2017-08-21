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

    override func awakeFromNib() {
        super.awakeFromNib()

        setupFriendImageView()

        setupFriendNameLabel()
    }

    private func setupFriendImageView() {

        let imageView = friendImageView!

        imageView.layer.masksToBounds = true

        imageView.layer.cornerRadius = imageView.frame.width/2

    }

    private func setupFriendNameLabel() {

        let label = friendNameLabel!

        label.font = UIFont(name: "Georgia-Bold", size: 20)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
