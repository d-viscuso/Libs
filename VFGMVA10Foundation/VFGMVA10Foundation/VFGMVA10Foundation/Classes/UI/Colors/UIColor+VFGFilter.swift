//
//  UIColor+VFGFilter.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 4/29/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

extension UIColor {
    /// Universal color (Hex) #007C92
    public static let VFGFilterSelectedBg = UIColor.init(
        named: "VFGFilterSelectedBg",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.blue

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGFilterUnselectedBg = UIColor.init(
        named: "VFGFilterUnselectedBg",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #666666
    */
    public static let VFGFilterUnselectedBgTwo = UIColor.init(
        named: "VFGFilterUnselectedBgTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGFilterSelectedText = UIColor.init(
        named: "VFGFilterSelectedText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGFilterUnselectedText = UIColor.init(
        named: "VFGFilterUnselectedText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.darkGray
}
