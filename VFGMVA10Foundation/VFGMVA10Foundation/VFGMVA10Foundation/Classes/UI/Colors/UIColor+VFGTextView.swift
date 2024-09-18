//
//  UIColor+VFGBorders.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 15/09/2022.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #007C92
    - Dark color (Hex) #007C92
    */
    public static let VFGTextViewBorderActiveColor = UIColor.init(
        named: "VFGTextViewBorderActiveColor",
        in: Bundle.foundation,
        compatibleWith: nil)

    /**
    - Light color (Hex) #0096AD
    - Dark color (Hex) #00B0CA
    */
    public static let VFGTextViewBorderActiveColorTwo = UIColor.init(
        named: "VFGTextViewBorderActiveColorTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #666666
    - Dark color (Hex) #666666
    */
    public static let VFGTextViewBorderInactiveColor = UIColor.init(
        named: "VFGTextViewBorderInactiveColor",
        in: Bundle.foundation,
        compatibleWith: nil)

    /**
    - Light color (Hex) #007C92
    - Dark color (Hex) #007C92
    */
    public static let VFGTextViewHintColor = UIColor.init(
        named: "VFGTextViewHintColor",
        in: Bundle.foundation,
        compatibleWith: nil)

    /**
    - Light color (Hex) #666666
    - Dark color (Hex) #666666
    */
    public static let VFGTextViewInfoTextColor = UIColor.init(
        named: "VFGTextViewInfoTextColor",
        in: Bundle.foundation,
        compatibleWith: nil)

    /**
    - Light color (Hex) #666666
    - Dark color (Hex) #666666
    */
    public static let VFGTextViewPlaceHolderColor = UIColor.init(
        named: "VFGTextViewPlaceHolderColor",
        in: Bundle.foundation,
        compatibleWith: nil)

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #333333
    */
    public static let VFGTextViewTextColor = UIColor.init(
        named: "VFGTextViewTextColor",
        in: Bundle.foundation,
        compatibleWith: nil)
}
