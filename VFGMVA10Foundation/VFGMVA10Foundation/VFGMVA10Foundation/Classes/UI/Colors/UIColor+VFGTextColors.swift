//
//  UIColor+VFGTextColors.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #0D0D0D
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGPrimaryText = UIColor.init(
        named: "VFGPrimaryText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Universal color (Hex) #0D0D0D
    */
    public static let VFGPrimaryDarkText = UIColor.init(
        named: "VFGPrimaryDarkText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #CCCCCC
    */
    public static let VFGRedPinkText = UIColor.init(
        named: "VFGRedPinkText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #F06666
    */
    public static var VFGRedCoralText = UIColor.init(
        named: "VFGRedCoralText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? .VFGRedText

    /**
    - Light color (Hex) #262626
    - Dark color (Hex) #F2F2F2
    */
    public static let VFGSecondaryText = UIColor.init(
        named: "VFGSecondaryText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGWhiteText = UIColor.init(
        named: "VFGWhiteText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #EB9600
    */
    public static let VFGRedOrangeText = UIColor.init(
        named: "VFGRedOrangeText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #BD0000
    - Dark color (Hex) #EB9600
    */
    public static let VFGRedOrangeTextMva12 = UIColor.init(
        named: "VFGRedOrangeTextMva12",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #E60000
    */
    public static let VFGRedText = UIColor.init(
        named: "VFGRedText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGRedWhiteText = UIColor.init(
        named: "VFGRedWhiteText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #CCCCCC
    - Dark color (Hex) #666666
    */
    public static let VFGUnselectedText = UIColor.init(
        named: "VFGUnselectedText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #007B92
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGOceanText = UIColor.init(
        named: "VFGOceanText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #008A00
    - Dark color (Hex) #A8B400
    */
    public static let VFGStatusText = UIColor.init(
        named: "VFGStatusText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #AFAFAF
    - Dark color (Hex) #666666
    */
    public static let VFGPlatinumText = UIColor.init(
        named: "VFGPlatinumText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #9B9B9B
    - Dark color (Hex) #CCCCCC
    */
    public static let VFGGreyText = UIColor.init(
        named: "VFGGreyText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.VFGSecondaryText

    /**
    - Light color (Hex) #717171
    - Dark color (Hex) #CCCCCC
    */
    public static let VFGGreySubText = UIColor.init(
        named: "VFGGreySubText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #262626
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGDarkGreyText = UIColor.init(
        named: "VFGDarkGreyText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
