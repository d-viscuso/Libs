//
//  UIImage+Password.swift
//  VFGMVA10Media
//
//  Created by Yahya Saddiq on 3/5/21.
//

import UIKit

extension UIImage {
    /// Include images with password visibility sign
    public enum VFGPassword {
        /// Image named *icShowPasswordInsights* in light and dark mode, used to declare that password is visible to see
        public static let show = UIImage(
            named: "icShowPasswordInsights",
            in: foundation,
            compatibleWith: nil
        )
        /// Image named *icHidePassword* in light and dark mode, used to declare that password isn't visible to see
        public static let hide = UIImage(
            named: "icHidePassword",
            in: foundation,
            compatibleWith: nil
        )
    }
}
