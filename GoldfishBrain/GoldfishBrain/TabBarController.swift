//
//  tabBarViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/17.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    var destinationCoordinates = [Double]() {

        didSet {

            print(123)

        }
    }

    var creatDoVC: CreateDoViewController?

    var profileVC: UIViewController?

}
