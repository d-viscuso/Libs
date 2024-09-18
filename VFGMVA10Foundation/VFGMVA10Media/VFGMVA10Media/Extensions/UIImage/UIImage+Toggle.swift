//
//  UIImage+Toggle.swift
//  VFGMVA10Media
//
//  Created by Yahya Saddiq on 3/2/21.
//

import UIKit

// swiftlint:disable nesting
extension UIImage {
    /// Include images with different type of toggle button shape
    public enum VFGToggle {
        /// Include toggle images with medium size
        public enum Medium {
            /// Image named *definition_toggle_on* with toggle turned on in light and dark mode
            public static let active = UIImage(
                named: "definition_toggle_on",
                in: foundation,
                compatibleWith: nil
            )
            /// Image named *toggleMediumInactive* with toggle turned off in light and dark mode
            public static let inactive = UIImage(
                named: "toggleMediumInactive",
                in: foundation,
                compatibleWith: nil
            )
        }
        /// Include toggle images with small size
        public enum Small {
            /// Image named *toggleSmallActive* with toggle turned on in light and dark mode
            public static let active = UIImage(
                named: "toggleSmallActive",
                in: foundation,
                compatibleWith: nil
            )
            /// Image named *toggleSmallInactive* with toggle turned off in light and dark mode
            public static let inactive = UIImage(
                named: "toggleSmallInactive",
                in: foundation,
                compatibleWith: nil
            )
        }
    }
    /// Include images with radio button shape
    public enum VFGRadioButton {
        /// Image named *definition_radio_button_on* with selected radio button in light and dark mode
        public static let active = UIImage(
            named: "definition_radio_button_on",
            in: foundation,
            compatibleWith: nil
        )
        /// Image named *definition_radio_button_off* with unselected radio button in light and dark mode
        public static let inactive = UIImage(
            named: "definition_radio_button_off",
            in: foundation,
            compatibleWith: nil
        )
    }
}
