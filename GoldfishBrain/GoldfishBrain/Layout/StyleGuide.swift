//
//  File.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/28.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import UIKit

// Color palette

extension UIColor {

    class var goldfishOrangeLight: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 171.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.7)
    }

    class var goldfishOrangeLight2: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 171.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.3)
    }

    class var goldfishRedLight: UIColor {
        return UIColor(red: 218.0 / 255.0, green: 52.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.7)
    }

    class var goldfishRedLight2: UIColor {
        return UIColor(red: 218.0 / 255.0, green: 52.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.3)
    }

    class var goldfishRed: UIColor {
        return UIColor(red: 218.0 / 255.0, green: 52.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }

    class var goldfishRedNavigation: UIColor {
        return UIColor(red: 206.0 / 255.0, green: 90.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    }

    class var goldfishOrangeSection: UIColor {
        return UIColor(red: 218.0 / 255.0, green: 114.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
    }

    class var goldfishOrange: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 171.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }

    class var textBackground: UIColor {
        return UIColor(red: 78.0 / 255.0, green: 77.0 / 255.0, blue: 77.0 / 255.0, alpha: 0.3)
    }

    class var buttonBackground: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.5)
    }

    class var buttonTitleBackground: UIColor {
        return UIColor(red: 229.0 / 255.0, green: 89.0 / 255.0, blue: 39.0 / 255.0, alpha: 0.7)
    }

    class var asiSandBrown: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 150.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    }

    class var asiBrownish: UIColor {
        return UIColor(red: 160.0 / 255.0, green: 98.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkSalmon: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 113.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkSand: UIColor {
        return UIColor(red: 166.0 / 255.0, green: 145.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    }

    class var asiPaleTwo: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 241.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }

    class var asiPaleGold: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 197.0 / 255.0, blue: 111.0 / 255.0, alpha: 1.0)
    }

    class var asiDenimBlue: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }

    class var asiCoolGrey: UIColor {
        return UIColor(red: 171.0 / 255.0, green: 179.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)
    }

    class var asiPale: UIColor {
        return UIColor(red: 1.0, green: 239.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }

    class var asiDustyOrange: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 96.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    }

    class var asiSlate: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 87.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkBlueGrey: UIColor {
        return UIColor(red: 8.0 / 255.0, green: 20.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    }

    class var asiBlack26: UIColor {
        return UIColor(white: 0.0, alpha: 0.26)
    }

    class var asiWhite: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }

    class var asiTealish85: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 184.0 / 255.0, blue: 208.0 / 255.0, alpha: 0.85)
    }

    class var asiCoolGreyTwo: UIColor {
        return UIColor(red: 165.0 / 255.0, green: 170.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }

    class var asiGreyish: UIColor {
        return UIColor(white: 178.0 / 255.0, alpha: 1.0)
    }

    class var asiCharcoalGrey: UIColor {
        return UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkishBlue: UIColor {
        return UIColor(red: 3.0 / 255.0, green: 63.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
    }

    class var asiBlack50: UIColor {
        return UIColor(white: 0.0, alpha: 0.5)
    }

    class var asiBlack10: UIColor {
        return UIColor(white: 0.0, alpha: 0.1)
    }

    class var asiBlack30: UIColor {
        return UIColor(white: 0.0, alpha: 0.3)
    }

    class var asiGreyishBrown: UIColor {
        return UIColor(red: 82.0 / 255.0, green: 66.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }

    class var asiSeaBlue: UIColor {
        return UIColor(red: 4.0 / 255.0, green: 107.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    }

    class var asiGreyishBrown75: UIColor {
        return UIColor(red: 82.0 / 255.0, green: 66.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.75)
    }

    class var asiBlack20: UIColor {
        return UIColor(white: 0.0, alpha: 0.2)
    }

    class var asiGrapefruit: UIColor {
        return UIColor(red: 1.0, green: 94.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    }

    class var asiLightishRed: UIColor {
        return UIColor(red: 1.0, green: 53.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    }

    class var asiTealish: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 184.0 / 255.0, blue: 208.0 / 255.0, alpha: 1.0)
    }

    class var asiPaleSalmon85: UIColor {
        return UIColor(red: 1.0, green: 174.0 / 255.0, blue: 171.0 / 255.0, alpha: 0.85)
    }
}

// Text styles

extension UIFont {
    class func asiTextStyle3Font() -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: 80.0)
    }

    class func asiTextStyle7Font() -> UIFont? {
        return UIFont(name: "Georgia-Bold", size: 50.0)
    }

    class func asiTextStyle19Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 24.0)
    }

    class func asiTextStyleFont() -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: 20.0)
    }

    class func asiTextStyle5Font() -> UIFont? {
        return UIFont(name: "Georgia-Bold", size: 18.0)
    }

    class func asiTextStyle14Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 18.0)
    }

    class func asiTextStyle6Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 18.0)
    }

    class func asiTextStyle8Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
    }

    class func asiTextStyle22Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
    }

    class func asiTextStyle11Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 16.0)
    }

    class func asiTextStyle20Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
    }

    class func asiTextStyle9Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 14.0)
    }

    class func asiTextStyle4Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 14.0)
    }

    class func asiTextStyle2Font() -> UIFont? {
        return UIFont(name: "PingFangTC-Regular", size: 14.0)
    }

    class func asiTextStyle15Font() -> UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightRegular)
    }

    class func asiTextStyle13Font() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
    }

    class func asiTextStyle18Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 12.0)
    }

    class func asiTextStyle21Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 12.0)
    }

    class func asiTextStyle16Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }

    class func asiTextStyle17Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }

    class func asiTextStyle10Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }

    class func asiTextStyle12Font() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
    }
}
