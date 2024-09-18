//
//  UIColor+VFGBars.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 6/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #4A4A4A
    */
    public static let VFGChartBarsUnselected = UIColor.init(
        named: "VFGChartBarsUnselected",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.lightGray

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGRedProgressBar = UIColor.init(
        named: "VFGRedProgressBar",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.lightGray

    /**
    - Light color (Hex) #E60000
    - Dark color (Hex) #FFFFFF
    */
    public static let VFGChartBarsActive = UIColor.init(
        named: "VFGChartBarsActive",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.lightGray

    /// Universal color (Hex) #E60000 with 30.0% Opacity
    public static let VFGChartBarsUnselectedRed = UIColor.init(
        named: "VFGChartBarsUnselectedRed",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.lightGray

    /**
    - Light color (Hex) #BEBEBE
    - Dark color (Hex) #494D4E
    */
    public static let VFGAluminiumProgressBar = UIColor.init(
        named: "VFGAluminiumProgressBar",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.lightGray
}
