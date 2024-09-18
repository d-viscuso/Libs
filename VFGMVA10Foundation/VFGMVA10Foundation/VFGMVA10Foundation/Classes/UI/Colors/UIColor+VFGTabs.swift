//
//  UIColor+VFGTabs.swift
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
    public static let VFGTabIconActive = UIColor.init(
        named: "VFGTabIconActive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #AFAFAF
    */
    public static let VFGTabIconInactive = UIColor.init(
        named: "VFGTabIconInactive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGTabLabelActive = UIColor.init(
        named: "VFGTabLabelActive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #AFAFAF
    */
    public static let VFGTabLabelInactive = UIColor.init(
        named: "VFGTabLabelInactive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
