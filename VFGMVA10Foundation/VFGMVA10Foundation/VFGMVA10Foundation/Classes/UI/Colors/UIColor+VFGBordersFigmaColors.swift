//
//  UIColor+VFGBordersFigmaColors.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 08/09/2022.
//

import Foundation

extension UIColor {
    public static var VFGSelectedCellBorder: UIColor {
        UIColor.init(
            named: "VFGSelectedCellBorder",
            in: Bundle.foundation,
            compatibleWith: nil) ?? UIColor.white
    }
    /**
    - Light color (Hex) #7E7E7E
    - Dark color (Hex) #7E7E7E
    */
    public static var VFGGreyBorder: UIColor {
        UIColor.init(
            named: "VFGGreyBorder",
            in: Bundle.foundation,
            compatibleWith: nil) ?? UIColor.white
    }
}
