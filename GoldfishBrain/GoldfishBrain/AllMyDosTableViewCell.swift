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

    @IBOutlet weak var travelDestinationTextView: UITextView!

    @IBOutlet weak var travelFinished: UILabel!

    @IBOutlet weak var travelNotified: UILabel! //到達目的地時通知狀態

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
