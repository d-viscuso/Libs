//
//  ErrorView.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 7/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// A configurable error card view with configurable try again button
open class ErrorView: UIView {
    @IBOutlet public weak var errorImageView: VFGImageView!
    @IBOutlet public weak var errorMessageLabel: VFGLabel!
    @IBOutlet public weak var tryAgainLabel: VFGLabel!
    @IBOutlet public weak var refreshImage: VFGImageView!

    /**
    Configuring error description and try again message

    - Parameter errorMessage: body message description
    - Parameter tryAgainMessage: button title
    */
    public func configure(
        errorMessage: String?,
        tryAgainMessage: String = "Try again",
        accessibilityIdInitial: String? = nil
    ) {
        guard let errorMessage = errorMessage,
            !errorMessage.isEmpty else {
            return
        }

        tryAgainLabel.text = tryAgainMessage
        errorMessageLabel.text = errorMessage
        setupAccessibilityIds(accessibilityIdInitial)
        setupAccessibilityLabels()
    }
    /// Set accessibility identifiers for *ErrorView* UI components
    /// - Parameters:
    ///    - accessibilityIdInitial: UI component accessibility identifier prefix text value
    open func setupAccessibilityIds(_ accessibilityIdInitial: String?) {
        guard var accessibilityIdInitial = accessibilityIdInitial else {
            return
        }

        if !accessibilityIdInitial.contains("error") {
            accessibilityIdInitial += "Error"
        }

        errorMessageLabel.accessibilityIdentifier = accessibilityIdInitial + "Description"
        errorImageView.accessibilityIdentifier = accessibilityIdInitial + "Icon"
        tryAgainLabel.accessibilityIdentifier = accessibilityIdInitial + "TryAgainText"
        refreshImage.accessibilityIdentifier = accessibilityIdInitial + "Arrow"
    }
}

// MARK: - Voice over
extension ErrorView {
    /// setup accessibility labels
    func setupAccessibilityLabels() {
        tryAgainLabel.accessibilityLabel = tryAgainLabel.text
        errorMessageLabel.accessibilityLabel = errorMessageLabel.text
    }
}
