//
//  AllMyDosTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/9.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class AllMyDosTableViewCell: UITableViewCell {

    @IBOutlet weak var travelDate: UILabel!

    @IBOutlet weak var travelDestination: UILabel!

    @IBOutlet weak var travelFinished: UILabel!

    @IBOutlet weak var travelNotified: UILabel! //到達目的地時通知狀態

    @IBOutlet weak var travelTimeImage: UIImageView!

    @IBOutlet weak var travelDestinationImage: UIImageView!

    @IBOutlet weak var travelFinishedImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupTravelTimeImage()

        setupTravelDestinationImage()

        setupTravelFinishedImage()

    }

    private func setupTravelTimeImage() {

        let image = travelTimeImage!

        image.tintColor = UIColor(red: 68.0/255.0, green: 196.0/255.0, blue: 192.0/255.0, alpha: 1)
        image.backgroundColor = UIColor.white
        image.layer.cornerRadius = image.frame.width/2
        image.dropShadow()

    }

    private func setupTravelDestinationImage() {

        let image = travelDestinationImage!

        image.tintColor = UIColor(red: 81.0/255.0, green: 155.0/255.0, blue: 202.0/255.0, alpha: 1)
        image.backgroundColor = UIColor.white
        image.layer.cornerRadius = image.frame.width/2
        image.dropShadow()

    }

    private func setupTravelFinishedImage() {

        let image = travelFinishedImage!

        image.tintColor = UIColor(red: 72.0/255.0, green: 110.0/255.0, blue: 161.0/255.0, alpha: 1)
        image.backgroundColor = UIColor.white
        image.layer.cornerRadius = image.frame.width/2
        image.dropShadow()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
