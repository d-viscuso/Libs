//
//  UIColor+VFGRedGradient.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #FF0000
    - Dark color (Hex) #E60000
    */
    public static let VFGRedGradientStart = UIColor.init(
        named: "VFGRedGradientStart",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.red

    /**
    - Light color (Hex) #A90000
    - Dark color (Hex) #990000
    */
    public static let VFGRedGradientEnd = UIColor.init(
        named: "VFGRedGradientEnd",
        in: Bundle.foundation,
        compatibleWith: nil)
        ?? UIColor(red: 169 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
}
