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

//    @IBOutlet weak var travelDestinationTextView: UITextView!

    @IBOutlet weak var travelDestination: UILabel!

    @IBOutlet weak var travelFinished: UILabel!

    @IBOutlet weak var travelNotified: UILabel! //到達目的地時通知狀態

    @IBOutlet weak var travelDataLabel: UILabel!

    @IBOutlet weak var travelDestinationLabel: UILabel!

    @IBOutlet weak var travelFinishedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupTravelDataLabel()

        setupTravelDestinationLabel()

        setupTravelFinishedLabel()
    }

    private func setupTravelDataLabel() {

        let label =  travelDataLabel!

        label.text = "出發時間："

    }

    private func setupTravelDestinationLabel() {

        let label =  travelDestinationLabel!

        label.text = "目的地點："
    }

    private func setupTravelFinishedLabel() {

        let label =  travelFinishedLabel!

        label.text = "行程結果："

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
