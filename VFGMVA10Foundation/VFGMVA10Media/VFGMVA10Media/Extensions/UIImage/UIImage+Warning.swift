//
//  UIImage+Warning.swift
//  VFGMVA10Media
//
//  Created by Yahya Saddiq on 3/5/21.
//

import UIKit

extension UIImage {
    /// Include images with different error and warning alert signs
    public enum VFGWarning {
        /// Image named *icWarningNotificationWhite* in general mode
        public static let white = UIImage(
            named: "icWarningNotificationWhite",
            in: foundation,
            compatibleWith: nil)
        /// Image named *icWarningHiLightTheme* in light and dark mode
        public static let high = UIImage(
            named: "icWarningHiLightTheme",
            in: foundation,
            compatibleWith: nil)
        /// Image named *icWarningMid* in light and dark mode
        public static let medium = UIImage(
            named: "icWarningMid",
            in: foundation,
            compatibleWith: nil)
    }
}
