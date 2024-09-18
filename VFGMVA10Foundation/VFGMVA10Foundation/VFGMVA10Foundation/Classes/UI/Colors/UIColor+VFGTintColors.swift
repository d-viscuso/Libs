//
//  UIColor+VFGTintColors.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 5/14/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGGreyTint = UIColor.init(
        named: "VFGGreyTint",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.gray

    /**
    - Light color (Hex) #2F90E2
    - Dark color (Hex) #14B0CA
    */
    public static let VFGTurquoiseTint = UIColor.init(
        named: "VFGTurquoiseTint",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.blue
}
