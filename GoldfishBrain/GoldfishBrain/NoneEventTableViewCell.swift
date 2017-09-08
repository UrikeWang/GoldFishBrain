//
//  NoneEventTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/16.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class NoneEventTableViewCell: UITableViewCell {

    @IBOutlet weak var noneEventLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    private func setupNoneEventLabel() {

        let label = noneEventLabel!

        label.text = "No trace event"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
