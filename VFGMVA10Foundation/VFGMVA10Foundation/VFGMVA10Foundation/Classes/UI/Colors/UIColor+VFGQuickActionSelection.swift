//
//  UIColor+VFGQuickActionSelection.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 7/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #007C92
    - Dark color (Hex) #00B0CA
    */
    public static let VFGActiveSelectionOutline = UIColor.init(
        named: "VFGActiveSelectionOutline",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGActiveSelectionText = UIColor.init(
        named: "VFGActiveSelectionText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.black

    /// Universal color (Hex) #999999
    public static let VFGDefaultSelectionOutline = UIColor.init(
        named: "VFGDefaultSelectionOutline",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGDefaultSelectionText = UIColor.init(
        named: "VFGDefaultSelectionText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.black
}
