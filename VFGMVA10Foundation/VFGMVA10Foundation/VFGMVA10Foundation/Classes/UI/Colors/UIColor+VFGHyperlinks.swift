//
//  UIColor+VFGHyperlinks.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #EB9700
    */
    public static let VFGLinkText = UIColor.init(
        named: "VFGLinkText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #EB9700
    */
    public static let VFGLinkWhiteText = UIColor.init(
        named: "VFGLinkWhiteText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #666666
    - Dark color (Hex) #EB9600
    */
    public static let VFGLinkAnthraciteText = UIColor.init(
        named: "VFGLinkAnthraciteText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #333333
    - Dark color (Hex) #EB9700
    */
    public static let VFGLinkDarkGreyText = UIColor.init(
        named: "VFGLinkDarkGreyText",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white
}
