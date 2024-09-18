//
//  UIColor+VFGAlerts.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /// Universal color (Hex) #008A00
    public static let VFGAlertPositive = UIColor.init(
        named: "VFGAlertPositive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #EB6100
    public static let VFGAlertNeutral = UIColor.init(
        named: "VFGAlertNeutral",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #E60000
    public static let VFGAlertError = UIColor.init(
        named: "VFGAlertError",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #999999
    public static let VFGAlertProcessing = UIColor.init(
        named: "VFGAlertProcessing",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
