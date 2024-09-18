//
//  UIColor+VFGListStatus.swift
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
    public static let VFGListStatusNatural = UIColor.init(
        named: "VFGListStatusNatural",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #EB9600
    */
    public static let VFGListStatusNegative = UIColor.init(
        named: "VFGListStatusNegative",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #009900
    - Dark color (Hex) #A8B400
    */
    public static let VFGListStatusPositive = UIColor.init(
        named: "VFGListStatusPositive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
