//
//  PopFriendCollectionViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/7.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class PopFriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var friendPhoto: UIImageView!

    @IBOutlet weak var friendNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupFriendPhoto()

        setupFriendNameLabel()
    }

    private func setupFriendPhoto() {

        let image = friendPhoto!

        image.layer.cornerRadius = image.frame.width/2

        image.layer.masksToBounds = true

    }

    private func setupFriendNameLabel() {

        let label = friendNameLabel!

        label.textAlignment = .center
    }

}
