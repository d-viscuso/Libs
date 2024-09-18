//
//  UIColor+VFGDividers.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #666666
    */
    public static let VFGGreyDividerOne = UIColor.init(
        named: "VFGGreyDividerOne",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #CCCCCC
    - Dark color (Hex) #333333
    */
    public static let VFGGreyDividerTwo = UIColor.init(
        named: "VFGGreyDividerTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF with 32.0% Opacity
    public static let VFGGreyDividerThree = UIColor.init(
        named: "VFGGreyDividerThree",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #BEBEBE
    - Dark color (Hex) #333333
    */
    public static let VFGGreyDividerFour = UIColor.init(
        named: "VFGGreyDividerFour",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #BEBEBE
    - Dark color (Hex) #666666
    */
    public static let VFGGreyDividerSix = UIColor.init(
        named: "VFGGreyDividerSix",
        in: Bundle.foundation,
        compatibleWith: nil) ?? .gray

    /// Universal color (Hex) #F2F2F2
    public static let VFGGreyDividerSeven = UIColor.init(
        named: "VFGGreyDividerSeven",
        in: .foundation,
        compatibleWith: nil) ?? .gray
}
