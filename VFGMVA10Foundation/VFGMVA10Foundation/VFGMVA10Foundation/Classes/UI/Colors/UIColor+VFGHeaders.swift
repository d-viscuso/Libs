//
//  UIColor+VFGHeaders.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGWhiteHeader = UIColor.init(
        named: "VFGWhiteHeader",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #333333
    */
    public static let VFGRedHeader = UIColor.init(
        named: "VFGRedHeader",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGDarkHeader = UIColor.init(
        named: "VFGDarkHeader",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGDarkGreyTwoHeader = UIColor.init(
        named: "VFGDarkGreyTwoHeader",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.darkGray

    /// Universal color (Hex) #333333
    public static let VFGDarkGreyHeader = UIColor.init(
        named: "VFGDarkGreyHeader",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.darkGray
}
