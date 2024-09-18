//
//  UIColor+CustomColor.swift
//  VFGMVA10
//
//  Created by Mohamed Mahmoud Zaki on 2/28/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    class var boldText: UIColor {
        return UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
    }

    class func VFGVeryLightPink(alpha: CGFloat = 1) -> UIColor {
        return UIColor(
            red: 235 / 255.0,
            green: 235 / 255.0,
            blue: 235 / 255.0,
            alpha: alpha)
    }

    class func regularText(alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: alpha)
    }

    class var dashboardSuccessGradient: [CGColor] {
        return [
            UIColor(
                red: 250 / 255,
                green: 250 / 255,
                blue: 250 / 255,
                alpha: 1.0).cgColor,
            UIColor(
                red: 1,
                green: 1,
                blue: 1,
                alpha: 1.0).cgColor
        ]
    }

    class var eiokTextWhiteColor: UIColor {
        return UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 1.0)
    }
}
