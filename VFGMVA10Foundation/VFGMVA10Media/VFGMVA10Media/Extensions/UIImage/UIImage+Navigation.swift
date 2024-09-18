//
//  UIImage+Close.swift
//  VFGMVA10Media
//
//  Created by Yahya Saddiq on 3/5/21.
//

import UIKit

extension UIImage {
    /// Include images with the **X** sign to be used for close buttons
    public enum VFGClose {
        /// Image named *icCloseWhite* with the **X** sign in general mode
        public static let white = UIImage(
            named: "icCloseWhite",
            in: foundation,
            compatibleWith: nil
        )
        /// Image named *icClose* with the **X** sign in light and dark modes
        public static let dynamic = UIImage(
            named: "icClose",
            in: foundation,
            compatibleWith: nil
        )
    }
    /// Include images with the arrow sign to be used for back buttons
    public enum VFGArrow {
        public static let right = UIImage(
            named: "icArrowLeft",
            in: foundation,
            compatibleWith: nil
        )
        /// Image named *icArrowLeft*, arrow refer to the left side in light and dark modes
        public static let left = UIImage(
            named: "icArrowLeft",
            in: foundation,
            compatibleWith: nil
        )
    }
}
