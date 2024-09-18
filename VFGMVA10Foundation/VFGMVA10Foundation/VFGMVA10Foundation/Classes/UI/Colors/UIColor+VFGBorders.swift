//
//  UIColor+VFGBorders.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 6/2/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #EB9600
    */
    public static let VFGRedOrangeBorder = UIColor.init(
        named: "VFGRedOrangeBorder",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #999999
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGGreyWhiteBorder = UIColor.init(
        named: "VFGGreyWhiteBorder",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
