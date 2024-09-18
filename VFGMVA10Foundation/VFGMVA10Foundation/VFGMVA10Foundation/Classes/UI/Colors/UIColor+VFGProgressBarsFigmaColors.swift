//
//  UIColor+VFGProgressBarsFigmaColors.swift
//  VFGMVA10Foundation
//
//  Created by Ashraf Dewan on 11/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #FFFFFF
    */
    public static var filledRedProgressBar: UIColor? {
        UIColor.init(
            named: "VFGFilledRedProgressBar",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #BEBEBE
    - Dark color (Hex) #494D4E
    */
    public static var unfilledGrayProgressBar: UIColor? {
        UIColor.init(
            named: "VFGUnfilledGrayProgressBar",
            in: .foundation,
            compatibleWith: nil)
    }
}
