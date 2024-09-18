//
//  UIColor+VFGAddonsTimeline.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 7/20/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
extension UIColor {
    /// Universal color (Hex) #007B92
    public static let VFGTimelineCellActive = UIColor.init(
        named: "VFGTimelineCellActive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #999999
    - Dark color (Hex) #AFAFAF
    */
    public static let VFGTimelineCellBorder = UIColor.init(
        named: "VFGTimelineCellBorder",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #CCCCCC
    - Dark color (Hex) #666666
    */
    public static let VFGTimelineSeparator = UIColor.init(
        named: "VFGTimelineSeparator",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
