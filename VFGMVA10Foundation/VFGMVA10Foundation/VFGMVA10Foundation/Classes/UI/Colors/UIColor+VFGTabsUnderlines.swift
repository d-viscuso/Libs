//
//  UIColor+VFGTabsUnderlines.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGTabsUnderline = UIColor.init(
        named: "VFGTabsUnderline",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #EB9600
    */
    public static let VFGTabsUnderlineRedOrange = UIColor.init(
        named: "VFGTabsUnderlineRedOrange",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGTabsUnderlineActiveText = UIColor.init(
        named: "VFGTabsUnderlineActiveText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #666666
    - Dark color (Hex) #CCCCCC
    */
    public static let VFGTabsUnderlineInactiveText = UIColor.init(
        named: "VFGTabsUnderlineInactiveText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGTabsUnderlinesHoverText = UIColor.init(
        named: "VFGTabsUnderlinesHoverText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
