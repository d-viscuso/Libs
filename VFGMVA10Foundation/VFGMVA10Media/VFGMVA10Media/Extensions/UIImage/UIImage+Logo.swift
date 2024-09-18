//
//  UIImage+Logo.swift
//  VFGMVA10Media
//
//  Created by Yahya Saddiq on 3/5/21.
//

import UIKit

extension UIImage {
    /// Include images with vodafone logo
    public enum VFGLogo {
        /// Image named *vodafoneLogoWhite* with vodafone logo in general mode
        public static let white = UIImage(
            named: "vodafoneLogoWhite",
            in: foundation,
            compatibleWith: nil
        )
        /// Image named *vodafoneLogo* with vodafone logo in light and dark mode
        public static let dynamic = UIImage(
            named: "vodafoneLogo",
            in: foundation,
            compatibleWith: nil
        )
    }
}
