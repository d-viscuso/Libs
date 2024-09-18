//
//  UIColor+VFGShimmer.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    - Light color (Hex) #EDEDED
    - Dark color (Hex) #464646
    */
    public static let VFGShimmerViewEdge = UIColor.init(
        named: "VFGShimmerViewEdge",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #DFDFDF
    - Dark color (Hex) #666666
    */
    public static let VFGShimmerViewCenter = UIColor.init(
        named: "VFGShimmerViewCenter",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #EBEBEB
    - Dark color (Hex) #EBEBEB
    */
    public static let VFGShimmerViewEdgeMVA12 = UIColor.init(
        named: "VFGShimmerViewEdgeMVA12",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #4B4B4B (ALPHA 0.6)
    - Dark color (Hex) #4B4B4B (ALPHA 0.6)
    */
    public static let VFGShimmerViewCenterMVA12 = UIColor.init(
        named: "VFGShimmerViewCenterMVA12",
        in: Bundle.foundation,
        compatibleWith: nil) ?? UIColor.white

    /**
    - Light color (Hex) #FFFFFF
    - Dark color (Hex) #EDEDED
    */
    public static var mva12ShimmerEdgeColored: UIColor? {
        UIColor.init(
            named: "VFGMVA12ShimmerEdgeColored",
            in: .foundation,
            compatibleWith: nil)
    }
    /**
    - Light color (Hex) #000000 with 10% Opacity
    - Dark color (Hex) #BEBEBE
    */
    public static var mva12ShimmerCenterColored: UIColor? {
        UIColor.init(
            named: "VFGMVA12ShimmerCenterColored",
            in: .foundation,
            compatibleWith: nil)
    }
}
