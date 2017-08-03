//
//  AddDoTableViewCell.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/2.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class AddDoTableViewCell: UITableViewCell {

    @IBOutlet weak var addDoButton: UIButton!
    
    private func setupAddDoButton() {
    
        addDoButton.layer.cornerRadius = 3
        
        addDoButton.layer.borderColor = UIColor.gray.cgColor
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
