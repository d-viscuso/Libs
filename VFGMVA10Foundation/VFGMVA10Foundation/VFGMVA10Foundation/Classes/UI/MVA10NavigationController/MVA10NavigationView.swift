//
//  MVA10NavigationView.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 12/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
/// Top view for *MVA10NavigationController* which contains title label & back and close button
class MVA10NavigationView: UIView {
    @IBOutlet weak var bottomDivider: UIView!
    @IBOutlet weak var backButton: VFGButton!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var closeButton: VFGButton!
    /// Determine if the *bottomDivider* is shown or not
    var hasDivider = true {
        didSet {
            self.bottomDivider.alpha = hasDivider ? 1 : 0
        }
    }
    /// Determine transparency status for the background (has a color or a clear one)
    var isTransparentBackground = false {
        didSet {
            self.backgroundColor = isTransparentBackground ? .clear : .VFGWhiteBackground
        }
    }
    var titleColor = UIColor.VFGPrimaryText
    /// Set the title text for *titleLabel*
    /// - Parameters:
    ///    - title: *titleLabel* text value
    ///    - accessibilityIdentifier: *titleLabel*  accessibility identifier
    func setTitle(title: String, accessibilityIdentifier: String = "") {
        let attributes = [
            NSAttributedString.Key.font: UIFont.vodafoneRegular(16.0),
            .foregroundColor: titleColor
        ]
        let attrString = NSAttributedString(string: title, attributes: attributes)

        titleLabel.attributedText = attrString
        titleLabel.accessibilityLabel = title
        titleLabel.accessibilityIdentifier = accessibilityIdentifier
    }
    /// Set colors for *MVA10NavigationView* and its components
    /// - Parameters:
    ///    - backgroundColor: Set background color for *MVA10NavigationView*
    ///    - titleColor: Set title color for *titleLabel*
    ///    - closeButtonColor: Set tint color for *closeButton*
    ///    - backButtonColor: Set tint color for *backButton*
    func setupColors(
        backgroundColor: UIColor,
        titleColor: UIColor,
        closeButtonColor: UIColor,
        backButtonColor: UIColor
    ) {
        self.backgroundColor = backgroundColor
        titleLabel.textColor = titleColor
        self.titleColor = titleColor

        let closeButtonImage = VFGFoundationAsset.Image.icClose?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.tintColor = closeButtonColor

        let backButtonImage = VFGFoundationAsset.Image.icArrowLeft?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = backButtonColor
    }
    /// set accessibility identifiers for back and close buttons
    /// - Parameters:
    ///    - closeButtonID: Set accessibility identifier for *closeButton*
    ///    - backButtonID: Set accessibility identifier for *backButton*
    func setAccessibilityIDs(closeButtonID: String = "", backButtonID: String = "") {
        closeButton.accessibilityIdentifier = closeButtonID
        backButton.accessibilityIdentifier = backButtonID
    }
    /// Set accessibility label for title label & close and back buttons
    /// - Parameters:
    ///    - closeButtonLabel: Set accessibility label for *closeButton*
    ///    - backButtonLabel: Set accessibility label for *backButton*
    ///    - titleAccessibilityLabel: Set accessibility label for *titleLabel*
    func setAccessibilityLabels(
        closeButtonLabel: String?,
        backButtonLabel: String?,
        titleAccessibilityLabel: String?
    ) {
        closeButton.accessibilityLabel = closeButtonLabel
        backButton.accessibilityLabel = backButtonLabel
        titleLabel.accessibilityLabel = titleAccessibilityLabel
    }
}
