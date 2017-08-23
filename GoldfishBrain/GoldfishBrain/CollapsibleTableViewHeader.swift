//
//  DoTableViewController+UITableViewHeaderFooterView.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/23.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import Foundation

protocol CollapsibleTableViewHeaderDelegate: class {

    func toggleSection(header: CollapsibleTableViewHeader, section: Int)

}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

    weak var delegate: CollapsibleTableViewHeaderDelegate?

    var section: Int = 0

    let titleLabel = UILabel()

    let arrowLabel = UILabel()

    override init(reuseIdentifier: String?) {

        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor(red: 218.0/255.0, green: 114.0/255.0, blue: 51.0/255.0, alpha: 0.8)

        let marginGuide = contentView.layoutMarginsGuide

        contentView.addSubview(arrowLabel)

        arrowLabel.textColor = UIColor.white
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true

        contentView.addSubview(titleLabel)

        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))

    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemnted")
    }

    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {

        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {

            return

        }

        delegate?.toggleSection(header: self, section: cell.section)

    }

    func setCollapsed(_ collapsed: Bool) {

        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)

    }

}
