//
//  DoTableViewController+UITableViewHeaderFooterView.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/23.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import Fundation

protocol CollapsibleTableViewHeaderDelegate: class {

    func toggleSection(header: CollapsibleTableViewHeader, section: Int)

}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

    weak var delegate: CollapsibleTableViewHeaderDelegate?

    var section: Int = 0

    func tapHeader( gestureRecognizer: UITapGetureRecognizer) {

    }

}
