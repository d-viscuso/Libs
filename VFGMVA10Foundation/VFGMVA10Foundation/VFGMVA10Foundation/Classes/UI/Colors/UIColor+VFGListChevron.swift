//
//  UIColor+VFGListChevron.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #EB9600
    */
    public static let VFGChevronColor = UIColor.init(
        named: "VFGChevronColor",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
