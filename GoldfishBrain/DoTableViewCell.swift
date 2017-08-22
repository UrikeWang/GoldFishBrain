//
//  DoTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/2.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class DoTableViewCell: UITableViewCell {

    @IBOutlet weak var doingTravelDataLabel: UILabel!

    @IBOutlet weak var doingTravelDateTitle: UILabel!

    @IBOutlet weak var doingTravelDestinationTitle: UILabel!

    @IBOutlet weak var doingToFriendTitle: UILabel!

    @IBOutlet weak var doingTravelDurationTitle: UILabel!

    @IBOutlet weak var doingTravelDate: UILabel!

    @IBOutlet weak var doingTravelDestination: UILabel!

    @IBOutlet weak var doingToFriend: UILabel!

    @IBOutlet weak var doingTravelDuration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupDoingTravelDateTitle()

        setupDoingTravelDestinationTitle()

        setupDoingToFriendTitle()

        setupDoingTravelDurationTitle()

    }

    private func setupDoingTravelDateTitle() {

        let label = doingTravelDateTitle!

        label.text = "出發時間："

    }

    private func setupDoingTravelDestinationTitle() {

        let label = doingTravelDestinationTitle!

        label.text = "目的地點："

    }

    private func setupDoingToFriendTitle() {

        let label = doingToFriendTitle!

        label.text = "通知朋友："

    }

    private func setupDoingTravelDurationTitle() {

        let label = doingTravelDurationTitle!

        label.text = "預估時間："

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
