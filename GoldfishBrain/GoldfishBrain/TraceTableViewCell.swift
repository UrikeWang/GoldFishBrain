//
//  TraceTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/10.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class TraceTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var dateImage: UIImageView!

    @IBOutlet weak var destinationImage: UIImageView!

    @IBOutlet weak var durationImage: UIImageView!

    @IBOutlet weak var friendName: UILabel!

    @IBOutlet weak var friendDoDate: UILabel!

    @IBOutlet weak var friendDoDestination: UILabel!

    @IBOutlet weak var friendDoDuration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCancelButton()

        setupFriendName()

        setupDateImage()

        setupDestinationImage()

        setupDurationImage()

    }

    private func setupFriendName() {

        let label = friendName!

        label.textColor = UIColor.darkGray

    }

    private func setupDateImage() {

        let image = dateImage!

        image.tintColor = UIColor(red: 204.0/255.0, green: 159.0/255.0, blue: 224.0/255.0, alpha: 1)
        image.backgroundColor = UIColor.white
        image.layer.cornerRadius = image.frame.width/2
        image.dropShadow()

    }

    private func setupDestinationImage() {

        let image = destinationImage!

        image.tintColor = UIColor(red: 134.0/255.0, green: 120.0/255.0, blue: 180.0/255.0, alpha: 1)
        image.backgroundColor = UIColor.white
        image.layer.cornerRadius = image.frame.width/2
        image.dropShadow()

    }

    private func setupDurationImage() {

        let image = durationImage!

        image.tintColor = UIColor(red: 97.0/255.0, green: 69.0/255.0, blue: 150.0/255.0, alpha: 1)
        image.backgroundColor = UIColor.white
        image.layer.cornerRadius = image.frame.width/2
        image.dropShadow()

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

        button.setTitle("取消追蹤朋友行程", for: .normal)

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
