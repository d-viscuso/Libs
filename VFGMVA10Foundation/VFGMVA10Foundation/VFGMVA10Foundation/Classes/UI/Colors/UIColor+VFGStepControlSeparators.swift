//
//  UIColor+VFGStepControlSeparators.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Kishk on 5/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
extension UIColor {
    /// Light color (Hex) #7e7e7e
    /// Dark color (Hex) #FFFFFF
    public static let VFGStepControlSeparatorInProgress = UIColor.init(
        named: "VFGStepControlSeparatorInProgress",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Light color (Hex) #CCCCCC
    /// Dark color (Hex) #666666
    public static let VFGStepControlSeparatorSkipAction = UIColor.init(
        named: "VFGStepControlSeparatorSkipAction",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
