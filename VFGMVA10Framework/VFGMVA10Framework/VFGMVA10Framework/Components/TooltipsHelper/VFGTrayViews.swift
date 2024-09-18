//
//  VFGTrayViews.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 17/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// Tray and subtray views
public enum VFGTrayViews {
    static let keyWindow = UIApplication.shared.keyWindow

    /// Tray views
    public enum Tray {
        /// Tobi face
        public static func tobi(with id: String) -> UIView? {
            keyWindow?.view(withId: id)
        }

        /// First tray item
        static func firstItem(with id: String) -> UIButton? {
            keyWindow?.view(withId: id) as? UIButton
        }

        /// Open tray first Item action
        public static func openFirstItem(with id: String) {
            firstItem(with: id)?.sendActions(for: .touchUpInside)
        }
    }

    /// subtray tooltips
    public enum Subtray {
        /// Subtray main view
        public static func main(with id: String) -> UIView? {
            keyWindow?.view(withId: id)
        }

        /// Subtray close button
        static func subtrayCloseButton(with id: String) -> UIButton? {
            keyWindow?.view(withId: id) as? UIButton
        }

        /// Subtray close button action
        public static func closeSubtray(with id: String) {
            subtrayCloseButton(with: id)?.sendActions(for: .touchUpInside)
        }
    }
}
