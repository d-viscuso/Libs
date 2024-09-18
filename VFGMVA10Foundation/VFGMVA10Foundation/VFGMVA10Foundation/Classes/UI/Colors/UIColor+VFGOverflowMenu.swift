//
//  UIColor+VFGOverflowMenu.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 26/05/2021.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGOverflowMenuBackground = UIColor.init(
        named: "VFGOverflowMenuBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #494D4E
    */
    public static let VFGOverflowMenuSelectedCell = UIColor.init(
        named: "VFGOverflowMenuSelectedCell",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #666666
    */
    public static let VFGOverflowMenuSeparator = UIColor.init(
        named: "VFGOverflowMenuSeparator",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
