//
//  NoneDoTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/9.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class NoneDoTableViewCell: UITableViewCell {

//    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var note1Label: UILabel!

    @IBOutlet weak var note2Label: UILabel!

    @IBOutlet weak var note3Label: UILabel!

    @IBOutlet weak var note4Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

//        setupTitleLabel()

        setupNote1Label()

        setupNote2Label()

        setupNote3Label()

        setupNote4Label()

    }

//    private func setupTitleLabel() {
//
//        let label = titleLabel!
//
//        label.text = "使用方式"
//
//    }

    private func setupNote1Label() {

        let label = note1Label!

        label.text = "點選右上方按鈕，即可建立您的行程"

    }

    private func setupNote2Label() {

        let label = note2Label!

        label.text = "建立行程後，會自動發送行程通知給您選取的朋友"

    }

    private func setupNote3Label() {

        let label = note3Label!

        label.text = "若沒有好友，是無法進行行程通知的喔！請先於Chat頁面新增好友"

    }

    private func setupNote4Label() {

        let label = note4Label!

        label.text = "新增行程時，原本尚未完成的行程會被取消掉喔！"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
