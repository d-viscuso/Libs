//
//  UIColor+VFGPasswordIndicator.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 09/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #CCCCCC
    - Dark color (Hex) #666666
    */
    public static let VFGPasswordIndicatorDisabled = UIColor.init(
        named: "VFGPasswordIndicatorDisabled",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.gray

    /**
    - Light color (Hex)#009900
    - Dark color (Hex) #009900
    */
    public static let VFGPasswordIndicatorEnabled = UIColor.init(
        named: "VFGPasswordIndicatorEnabled",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.green
}
