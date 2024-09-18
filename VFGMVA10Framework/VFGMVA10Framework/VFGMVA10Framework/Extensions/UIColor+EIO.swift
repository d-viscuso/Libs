//
//  UIColor+EIO.swift
//  VFGMVA10Group
//
//  Created by Tomasz Czyżak on 24/07/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIColor {
    class func headerTint(with status: EIOStatus) -> UIColor {
        if status == .success {
            return .VFGDarkGreyTwoHeader
        }
        return .white
    }

    class func indicator(with status: EIOStatus) -> UIColor {
        if status == .success {
            return .VFGRedOrangeText
        }
        return .white
    }
}
