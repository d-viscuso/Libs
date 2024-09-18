//
//  UIColor+VFGBackgrounds.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #333333
    */
    public static let VFGWhiteBackground = UIColor.init(
        named: "VFGWhiteBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #222222
    */
    public static let VFGWhiteBackgroundTwo = UIColor.init(
        named: "VFGWhiteBackgroundTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #222222
    */
    public static let VFGVeryLightGreyBackground = UIColor.init(
        named: "VFGVeryLightGreyBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #990000
    */
    public static let VFGRedBackground = UIColor.init(
        named: "VFGRedBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #F4F4F4
    - Dark color (Hex) #212121
    */
    public static let VFGLightGreyBackground = UIColor.init(
        named: "VFGLightGreyBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #E60000
    public static let VFGRedDefaultBackground = UIColor.init(
        named: "VFGRedDefaultBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #007B92
    public static let VFGAquaBackground = UIColor.init(
        named: "VFGAquaBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #00697C
    public static var VFGDarkerAquaBackground = UIColor.init(
        named: "VFGDarkerAquaBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /// Universal color (Hex) #0095AD
    public static let VFGWhiterAquaBackground = UIColor.init(
        named: "VFGWhiterAquaBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Gradient color with colors list
    /// First color: Universal color (Hex) #FF0000
    /// Last color: Universal color (Hex) #A90000
    public static var quickActionsGradient: [CGColor] {
        return [
            UIColor(red: 1, green: 0 / 255, blue: 0 / 255, alpha: 1.0).cgColor,
            UIColor(red: 169 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0).cgColor
        ]
    }
    /// Gradient color with colors list
    /// First color: Universal color (Hex) #FFFFFF
    /// Last color: Universal color (Hex) #F4F4F4
    public static var giftOverlayGradient: [CGColor] {
        return [
            UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor,
            UIColor(red: 244 / 255, green: 244 / 255, blue: 244 / 255, alpha: 1.0).cgColor
        ]
    }
    /// Gradient color with colors list
    /// First color: Light color (Hex) #FF0000 & Dark color (Hex) #E60000
    /// Last color: Light color (Hex) #A90000 & Dark color (Hex) #990000
    public static var VFGRedGradientDynamic: [CGColor] {
        return [
            UIColor.VFGRedGradientStart.cgColor,
            UIColor.VFGRedGradientEnd.cgColor
        ]
    }
    /// Gradient color with colors list
    /// First color: Light color (Hex) #E60000 & Dark color (Hex) #24282B
    /// Last color: Light color (Hex) #820000 & Dark color (Hex) #212121
    public static var VFGBackgroundRedGradient: [CGColor] {
        return [
            UIColor.VFGVodafoneRed.cgColor,
            UIColor.VFGVodafoneMaroon.cgColor
        ]
    }
    /// Gradient color with colors list
    /// First color: Light color (Hex) #FAFAFA & Dark color (Hex) #25282B
    /// Last color: Light color (Hex) #F4F4F4 & Dark color (Hex) #222222
    public static var VFGDashBoardGradient: [CGColor] {
        return [
            UIColor.VFGVodafonePlatinum.cgColor,
            UIColor.VFGVodafoneLightGrey.cgColor
        ]
    }
    /// Gradient color with colors list
    /// First color: Universal color (Hex) #FAFAFA
    /// Last color: Universal color (Hex) #EBEBEB
    public static var VFGDashBoardLightGradient: [CGColor] {
        return [
            UIColor.VFGVodafoneLightPlatinum.cgColor,
            UIColor.VFGVeryLightGreyLightBackground.cgColor
        ]
    }
    /// Gradient color with colors list
    /// First color: Universal color (Hex) #25282B
    /// Last color: Universal color (Hex) #222222
    public static var VFGDashBoardDarkGradient: [CGColor] {
        return [
            UIColor.VFGVodafoneDarkPlatinum.cgColor,
            UIColor.VFGVeryLightGreyDarkBackground.cgColor
        ]
    }
    /// Gradient color with colors list
    /// First color: Universal color (Hex) #E60000
    /// Last color: Universal color (Hex) #820000
    public static var VFGDiscoverRedGradient: [CGColor] {
        return [
            UIColor.VFGRedDefaultBackground.cgColor,
            UIColor.VFGRedBackgroundTwo.cgColor
        ]
    }
    /// Gradient color with colors list
    /// Universal color (Hex) #0095AD
    /// Universal color (Hex) #007B92
    public static var VFGCVMBlueGradient: [CGColor] {
        return [
            UIColor.VFGWhiterAquaBackground.cgColor,
            UIColor.VFGAquaBackground.cgColor
        ]
    }
    /// Light color (Hex) #820000
    /// Dark color (Hex) #212121
    public static var VFGVodafoneMaroon = UIColor.init(
        named: "VFGVodafoneMaroon",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Light color (Hex) #E60000
    /// Dark color (Hex) #24282B
    public static var VFGVodafoneRed = UIColor.init(
        named: "VFGVodafoneRed",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Light color (Hex) #FAFAFA
    /// Dark color (Hex) #25282B
    public static var VFGVodafonePlatinum = UIColor.init(
        named: "VFGVodafonePlatinum",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Light color (Hex) #F4F4F4
    /// Dark color (Hex) #222222
    public static var VFGVodafoneLightGrey = UIColor.init(
        named: "VFGVodafoneLightGrey",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Universal color (Hex) #820000
    public static var VFGRedBackgroundTwo = UIColor.init(
        named: "VFGRedBackgroundTwo",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Light color (Hex) #E60000
    /// Dark color (Hex) #222222
    public static let VFGStatusBarBackground = UIColor.init(
        named: "VFGStatusBarBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Universal color (Hex) #EBEBEB
    public static let VFGVeryLightGreyLightBackground = UIColor.init(
        named: "VFGVeryLightGreyLightBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Universal color (Hex) #222222
    public static let VFGVeryLightGreyDarkBackground = UIColor.init(
        named: "VFGVeryLightGreyDarkBackground",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Universal color (Hex) #FAFAFA
    public static let VFGVodafoneLightPlatinum = UIColor.init(
        named: "VFGVodafoneLightPlatinum",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /// Universal color (Hex) #25282B
    public static let VFGVodafoneDarkPlatinum = UIColor.init(
        named: "VFGVodafoneDarkPlatinum",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
    /**
    - Light color (Hex) #BEBEBE
    - Dark color (Hex) #333333
    */
    public static let VFGGreyDividerFive = UIColor.init(
        named: "VFGGreyDividerFive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #F2F2F2
    - Dark color (Hex) #212121
    */
    public static let VFGDarkGreyBackground = UIColor.init(
        named: "VFGDarkGreyBackground",
        in: .foundation,
        compatibleWith: nil) ?? .darkGray
}
