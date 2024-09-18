//
//  UIColor+Mode.swift
//  VFGMVA10Framework
//
//  Created by Raquel on 28/11/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    static func setColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { traitCollection -> UIColor in
                return traitCollection.userInterfaceStyle == .light ? lightColor : darkColor
            }
        } else {
            return lightColor
        }
    }
}
