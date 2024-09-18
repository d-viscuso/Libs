//
//  AppErrorScreenViewController.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 3/15/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

/// A configurable view that can be used to show app errors
public class AppErrorScreenViewController: UIViewController {
    @IBOutlet weak var errorTitle: VFGLabel!
    @IBOutlet weak var errorMessage: VFGLabel!
    @IBOutlet weak var buttonAction: VFGButton!
    @IBOutlet weak var dismissAction: VFGButton!
    @IBOutlet weak var errorImageView: VFGImageView!

    /// Controls the visibility of the close button in the top right corner
    private var hasDismissAction: Bool {
        appErrorDismissAction != nil
    }
    /// *buttonAction* press action
    /// This action should be used to try fetching current screen data again to dismiss error and present data
    public var appErrorButtonAction: (() -> Void)?
    /// *dismissAction* press action,
    /// Check if *dismissAction* should be hidden or not,
    /// Handle dismissing *AppErrorScreenViewController*
    public var appErrorDismissAction: (() -> Void)? {
        didSet {
            dismissAction.isHidden = !hasDismissAction
        }
    }

    /**
    Configuring error title and description

    - Parameter title: header title
    - Parameter message: body message description
    - Parameter buttonText: button title
    */
    public func configure(
        title: String,
        message: String,
        buttonText: String,
        accessibilityIdInitial: String? = nil,
        titleFontSize: CGFloat = 30,
        messageFontSize: CGFloat = 17
    ) {
        if !title.isEmpty,
            !description.isEmpty,
            !buttonText.isEmpty {
            errorTitle.text = title
            errorMessage.text = message
            errorTitle.font = UIFont.vodafoneBold(titleFontSize)
            errorMessage.font = UIFont.vodafoneRegular(messageFontSize)
            buttonAction.setTitle(buttonText, for: .normal)
        }

        setupAccessibilityIds(accessibilityIdInitial)
    }

    @IBAction func buttonActionPressed(_ sender: Any) {
        appErrorButtonAction?()
    }

    @IBAction func dismissActionPressed(_ sender: Any) {
        appErrorDismissAction?()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        _ = self.view
    }

    func setupAccessibilityIds(_ accessibilityIdInitial: String?) {
        guard let accessibilityIdInitial = accessibilityIdInitial else {
            return
        }

        errorTitle.accessibilityIdentifier = accessibilityIdInitial + "errorTitle"
        errorMessage.accessibilityIdentifier = accessibilityIdInitial + "errorDesc"
        errorImageView.accessibilityIdentifier = accessibilityIdInitial + "warningIcon"
        buttonAction.accessibilityIdentifier = accessibilityIdInitial + "actionButton"
        dismissAction.accessibilityIdentifier = accessibilityIdInitial + "actionDismiss"
    }
}
