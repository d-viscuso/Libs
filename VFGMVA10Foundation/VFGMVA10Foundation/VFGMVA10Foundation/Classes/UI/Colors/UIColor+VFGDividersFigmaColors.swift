//
//  UIColor+VFGDividersFigmaColors.swift
//  VFGMVA10Foundation
//
//  Created by Ashraf Dewan on 08/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #BEBEBE
    - Dark color (Hex) #666666
    */
    public static var firstDivider: UIColor? {
        UIColor.init(
            named: "VFGFirstDivider",
            in: .foundation,
            compatibleWith: nil)
    }
}
