//
//  UIColor+VFGTextFigmaColors.swift
//  VFGMVA10Foundation
//
//  Created by Moustafa Hegazy on 30/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #0D0D0D
    - Dark color (Hex) #FFFFFF
    */
    public static var primaryTextColor: UIColor? {
        UIColor.init(
            named: "VFGPrimaryTextColor",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #262626
    - Dark color (Hex) #F2F2F2
    */
    public static var secondaryTextColor: UIColor? {
        UIColor.init(
            named: "VFGSecondaryTextColor",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #BD0000
    - Dark color (Hex) #F06666
    */
    public static var errorText: UIColor? {
        UIColor.init(
            named: "VFGErrorText",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #BD0000
    - Dark color (Hex) #F06666
    */
    public static var linksRedText: UIColor? {
        UIColor.init(
            named: "VFGLinksRedText",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #008A00
    - Dark color (Hex) #A8B400
    */
    public static var statusTextColor: UIColor? {
        UIColor.init(
            named: "VFGStatusTextColor",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #FFFFFF
    */
    public static var redTextColor: UIColor? {
        UIColor.init(
            named: "VFGRedTextColor",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #00697C
    - Dark color (Hex) #00697C
    */
    public static var VFGSelectedText: UIColor? {
        UIColor.init(
            named: "VFGSelectedText",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #FFFFFF with 38% Opacity
    - Dark color (Hex) #0D0D0D with 38% Opacity
    */
    public static var secondaryButtonTextColor: UIColor? {
        UIColor.init(
            named: "VFGSecondaryButtonTextColor",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #0D0D0D
    */
    public static var alt1PressedButtonTextColor: UIColor? {
        UIColor.init(
            named: "VFGAlt1PressedButtonTextColor",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #0D0D0D
    - Dark color (Hex) #FFFFFF
    */
    public static var alt1DefaultButtonTextColor: UIColor? {
        UIColor.init(
            named: "VFGAlt1DefaultButtonTextColor",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #0D0D0D
    */
    public static var alt2PressedButtonTextColor: UIColor? {
        UIColor.init(
            named: "VFGAlt2PressedButtonTextColor",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #0D0D0D
    - Dark color (Hex) #FFFFFF
    */
    public static var alt2DefaultButtonTextColor: UIColor? {
        UIColor.init(
            named: "VFGAlt2DefaultButtonTextColor",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /// Universal color (Hex) #0D0D0D
    public static var primaryButtonColoredText: UIColor? {
        UIColor.init(
            named: "VFGPrimaryButtonColoredText",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /// Universal color (Hex) #FFFFFF
    public static var secondaryColoredButtonText: UIColor? {
        UIColor.init(
            named: "VFGSecondaryColoredButtonText",
            in: Bundle.foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #00697C
    - Dark color (Hex) #00697C
    */
    public static var selectedColoredButtonText: UIColor? {
        UIColor.init(
            named: "VFGSelectedColoredButtonText",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #0D0D0D
    - Dark color (Hex) #FFFFFF
    */
    public static var unselectedColoredButtonText: UIColor? {
        UIColor.init(
            named: "VFGUnselectedColoredButtonText",
            in: .foundation,
            compatibleWith: nil)
    }
}
