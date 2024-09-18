//
//  UIColor+VFGTabsUnderlinesFigmaColors.swift
//  VFGMVA10Foundation
//
//  Created by Ashraf Dewan on 08/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #FFFFFF
    */
    public static var tabsRedUnderline: UIColor? {
        UIColor.init(
            named: "VFGTabsRedUnderline",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #EA1A1A
    */
    public static var tabsRedDefaultUnderline: UIColor? {
        UIColor.init(
            named: "VFGTabsRedDefaultUnderline",
            in: .foundation,
            compatibleWith: nil)
    }
}
