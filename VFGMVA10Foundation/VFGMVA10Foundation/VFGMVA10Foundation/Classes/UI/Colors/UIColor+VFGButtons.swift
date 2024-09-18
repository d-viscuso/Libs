//
//  UIColor+VFGButtons.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /// Universal color (Hex) #E60000
    public static let VFGPrimaryButton = UIColor.init(
        named: "VFGPrimaryButton",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #990000
    public static let VFGPrimaryButtonActive = UIColor.init(
        named: "VFGPrimaryButtonActive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #990000
    public static let VFGPrimaryButtonActiveRedBG = UIColor.init(
        named: "VFGPrimaryButtonActiveRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGPrimaryButtonActiveText = UIColor.init(
        named: "VFGPrimaryButtonActiveText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGPrimaryButtonActiveTextRedBG = UIColor.init(
        named: "VFGPrimaryButtonActiveTextRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #E60000
    */
    public static let VFGPrimaryButtonRedBG = UIColor.init(
        named: "VFGPrimaryButtonRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGPrimaryButtonText = UIColor.init(
        named: "VFGPrimaryButtonText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGPrimaryButtonTextRedBG = UIColor.init(
        named: "VFGPrimaryButtonTextRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #FFFFFF with 0.0% Opacity
    */
    public static let VFGSecondaryButton = UIColor.init(
        named: "VFGSecondaryButton",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /**
    - Light color (Hex) #F4F4F4
    - Dark color (Hex) #494D4E
    */
    public static let VFGSecondaryButtonActive = UIColor.init(
        named: "VFGSecondaryButtonActive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGSecondaryButtonActiveOutline = UIColor.init(
        named: "VFGSecondaryButtonActiveOutline",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #494D4E
    */
    public static let VFGSecondaryButtonActiveRedBG = UIColor.init(
        named: "VFGSecondaryButtonActiveRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGSecondaryButtonActiveText = UIColor.init(
        named: "VFGSecondaryButtonActiveText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGSecondaryButtonActiveTextRedBG = UIColor.init(
        named: "VFGSecondaryButtonActiveTextRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGSecondaryButtonTextRedBG = UIColor.init(
        named: "VFGSecondaryButtonTextRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Universal color (Hex) #999999
    public static let VFGSecondaryButtonOutline = UIColor.init(
        named: "VFGSecondaryButtonOutline",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGSecondaryButtonRedBG = UIColor.init(
        named: "VFGSecondaryButtonRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGSecondaryButtonText = UIColor.init(
        named: "VFGSecondaryButtonText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #666666
    - Dark color (Hex) #AEAEAE
    */
    public static let VFGTertiaryButton = UIColor.init(
        named: "VFGTertiaryButton",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #CCCCCC
    */
    public static let VFGTertiaryButtonActive = UIColor.init(
        named: "VFGTertiaryButtonActive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGTertiaryButtonActiveText = UIColor.init(
        named: "VFGTertiaryButtonActiveText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGTertiaryButtonText = UIColor.init(
        named: "VFGTertiaryButtonText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #CCCCCC
    - Dark color (Hex) #666666
    */
    public static let VFGDisabledButton = UIColor.init(
        named: "VFGDisabledButton",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #CCCCCC
    - Dark color (Hex) #666666
    */
    public static let VFGDisabledButtonRedBG = UIColor.init(
        named: "VFGDisabledButtonRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGDisabledButtonText = UIColor.init(
        named: "VFGDisabledButtonText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGDisabledButtonTextRedBG = UIColor.init(
        named: "VFGDisabledButtonTextRedBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #666666
    public static let VFGDisabledButtonDarkBG = UIColor.init(
        named: "VFGDisabledButtonDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGDisabledButtonTextDarkBG = UIColor.init(
        named: "VFGDisabledButtonTextDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #990000
    public static let VFGPrimaryButtonActiveDarkBG = UIColor.init(
        named: "VFGPrimaryButtonActiveDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGPrimaryButtonActiveTextDarkBG = UIColor.init(
        named: "VFGPrimaryButtonActiveTextDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #E60000
    public static let VFGPrimaryButtonDarkBG = UIColor.init(
        named: "VFGPrimaryButtonDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGPrimaryButtonTextDarkBG = UIColor.init(
        named: "VFGPrimaryButtonTextDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #4A4D4E
    public static let VFGSecondaryButtonActiveDarkBG = UIColor.init(
        named: "VFGSecondaryButtonActiveDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #EBEBEB
    public static let VFGSecondaryButtonActiveDarkBGTwo = UIColor.init(
        named: "VFGSecondaryButtonActiveDarkBGTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGSecondaryButtonActiveOutlineDarkBG = UIColor.init(
        named: "VFGSecondaryButtonActiveOutlineDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGSecondaryButtonActiveTextDarkBG = UIColor.init(
        named: "VFGSecondaryButtonActiveTextDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGSecondaryButtonActiveTextDarkBGTwo = UIColor.init(
        named: "VFGSecondaryButtonActiveTextDarkBGTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGSecondaryButtonDarkBG = UIColor.init(
        named: "VFGSecondaryButtonDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGSecondaryButtonDarkBGTwo = UIColor.init(
        named: "VFGSecondaryButtonDarkBGTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGSecondaryButtonOutlineDarkBG = UIColor.init(
        named: "VFGSecondaryButtonOutlineDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #FFFFFF
    public static let VFGSecondaryButtonTextDarkBG = UIColor.init(
        named: "VFGSecondaryButtonTextDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGSecondaryButtonTextDarkBGTwo = UIColor.init(
        named: "VFGSecondaryButtonTextDarkBGTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #CCCCCC
    public static let VFGTertiaryButtonActiveDarkBG = UIColor.init(
        named: "VFGTertiaryButtonActiveDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Universal color (Hex) #333333
    public static let VFGTertiaryButtonActiveTextDarkBG = UIColor.init(
        named: "VFGTertiaryButtonActiveTextDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #AEAEAE
    public static let VFGTertiaryButtonDarkBG = UIColor.init(
        named: "VFGTertiaryButtonDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGTertiaryButtonTextDarkBG = UIColor.init(
        named: "VFGTertiaryButtonTextDarkBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGLogoutButtonText = UIColor.init(
        named: "VFGLogoutButtonText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.black

    /// Universal color (Hex) #FFFFFF
    public static let VFGLogoutButtonBG = UIColor.init(
        named: "VFGLogoutButtonBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGTopUpButtonText = UIColor.init(
        named: "VFGTopUpButtonText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.black

    /// Universal color (Hex) #FFFFFF
    public static let VFGStoryButtonBG = UIColor.init(
        named: "VFGStoryButtonBG",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #333333
    public static let VFGStoryButtonText = UIColor.init(
        named: "VFGStoryButtonText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.black
}
