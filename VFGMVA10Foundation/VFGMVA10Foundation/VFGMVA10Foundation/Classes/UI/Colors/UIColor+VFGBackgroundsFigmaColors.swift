//
//  UIColor+VFGBackgroundsFigmaColors.swift
//  VFGMVA10Foundation
//
//  Created by Ashraf Dewan on 08/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #262626
    - Dark color (Hex) #F2F2F2
    */
    public static var darkBackground: UIColor? {
        UIColor.init(
            named: "VFGDarktBackground",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #F2F2F2
    - Dark color (Hex) #262626
    */
    public static var grayBackground: UIColor? {
        UIColor.init(
            named: "VFGGrayBackground",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #BEBEBE
    - Dark color (Hex) #494D4E
    */
    public static var darkGrayBackground: UIColor? {
        UIColor.init(
            named: "VFGDarkGrayBackground",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #0D0D0D
    */
    public static var lightBackground: UIColor? {
        UIColor.init(
            named: "VFGLightBackground",
            in: .foundation,
            compatibleWith: nil)
    }
    /// Universal color (Hex) #00697C
    public static var selectedItemBackground: UIColor? {
        UIColor.init(
            named: "VFGSelectedItemBackground",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #F2F2F2
    - Dark color (Hex) #0D0D0D
    */
    public static var unselectedItemBackground: UIColor? {
        UIColor.init(
            named: "VFGunselectedItemBackground",
            in: .foundation,
            compatibleWith: nil)
    }
}
