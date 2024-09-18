//
//  UIImage+Background.swift
//  VFGMVA10Media
//
//  Created by Yahya Saddiq on 3/5/21.
//

import UIKit

extension UIImage {
    /// Include images with gradient colors to be used as a background
    public enum VFGBackground {
        /// Image named *wavesGrey* with grey gradient colors in light and dark modes
        public static let grey = UIImage(
            named: "wavesGrey",
            in: foundation,
            compatibleWith: nil
        )
        /// Image named *wavesRed* with red gradient colors in light and dark modes
        public static let red = UIImage(
            named: "wavesRed",
            in: foundation,
            compatibleWith: nil
        )
    }
}
