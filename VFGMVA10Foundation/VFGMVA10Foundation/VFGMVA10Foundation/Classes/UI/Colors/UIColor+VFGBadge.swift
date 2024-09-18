//
//  UIColor+VFGBadge.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 16/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
extension UIColor {
    /// Universal color (Hex) #009900
    public static let VFGGreenBadge = UIColor.init(
        named: "VFGGreenBadge",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.lightGray
    /// Universal color (Hex) #EB6100
    public static let VFGOrangeBadge = UIColor.init(
        named: "VFGOrangeBadge",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.lightGray
    /// Universal color (Hex) #E60000
    public static let VFGRedBadge = UIColor.init(
        named: "VFGRedBadge",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.lightGray
}
