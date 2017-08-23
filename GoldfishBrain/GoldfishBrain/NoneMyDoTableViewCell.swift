//
//  NoneMyDoTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/22.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class NoneMyDoTableViewCell: UITableViewCell {

    @IBOutlet weak var noneMyDoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupNoneMyDoLabel()

    }

    private func setupNoneMyDoLabel() {

        let label = noneMyDoLabel!

        label.text = "現在沒有任何歷史行程！"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
