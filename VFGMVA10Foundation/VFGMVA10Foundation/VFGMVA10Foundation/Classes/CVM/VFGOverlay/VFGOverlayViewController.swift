//
//  VFGOverlayViewController.swift
//  VFGMVA10Foundation
//
//  Created by Ashraf Dewan on 14/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
/// Overlay with configurable content
public class VFGOverlayViewController: UIViewController {
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var backgroundImageView: VFGImageView!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!

    @IBOutlet weak var iconImageViewToTitleLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    /// View controller data
    var viewModel: VFGOverlayViewModel?
    /// Determine if view controller will have background image or an icon image
    var hasBackgroundImage = false
    let iconImageViewToTitleLabelConstant: CGFloat = 22
    let upperCornersRadiusConstant: CGFloat = 10
    /// View controller initializer to connect to its UI and configure its view model
    /// - Parameters:
    ///    - with viewModel: View controller data
    public convenience init(
        with viewModel: VFGOverlayViewModel
    ) {
        self.init(
            nibName: String(describing: VFGOverlayViewController.self),
            bundle: .foundation
        )
        self.viewModel = viewModel
        if viewModel.overlayType == .fullScreen {
            modalPresentationStyle = .fullScreen
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureOverlayTypeConstraints()
        configureImages()
        setupLabels()
        setupButtons()
    }

    func configureOverlayTypeConstraints() {
        if viewModel?.overlayType == .fullScreen {
            setupFullScreenConstraints()
        } else if viewModel?.overlayType == .flexHeight {
            setupFlexHeightConstraints()
        }
    }

    func setupFullScreenConstraints() {
        let deactivatedConstraints: [NSLayoutConstraint] = [
            containerViewTopConstraint,
            containerViewBottomConstraint
        ]
        NSLayoutConstraint.deactivate(deactivatedConstraints)
    }

    func setupFlexHeightConstraints() {
        iconImageViewToTitleLabelConstraint
            .constant = iconImageViewToTitleLabelConstant
        containerViewCenterYConstraint.isActive = false
        NSLayoutConstraint.changePriority(of: &containerViewTopConstraint, to: .required)
        NSLayoutConstraint.changePriority(of: &containerViewBottomConstraint, to: .required)
    }
    /// Images configuration in view controller based on given *viewModel*
    func configureImages() {
        if let backgroundImage = viewModel?.backgroundImage {
            backgroundImageView.image = backgroundImage
            iconImageView.isHidden = true
            hasBackgroundImage = true
        } else if let iconImage = viewModel?.iconImage {
            iconImageView.image = iconImage
            backgroundImageView.isHidden = true
        }
    }
    /// Labels configuration in view controller based on given *viewModel*
    func setupLabels() {
        guard let titleLabelText = viewModel?.titleLabelText,
            let subtitleLabelText = viewModel?.subtitleLabelText else {
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            return
        }
        titleLabel.text = titleLabelText
        titleLabel.textColor = .primaryTextColor
        subtitleLabel.text = subtitleLabelText
        subtitleLabel.textColor = .primaryTextColor
    }
    /// Buttons configuration in view controller based on given *viewModel*
    func setupButtons() {
        configureCloseButton()
        primaryButton.setTitle(viewModel?.primaryButtonText, for: .normal)
        guard let secondaryButtonText = viewModel?.secondaryButtonText else {
            secondaryButton.isHidden = true
            return
        }
        secondaryButton.setTitle(secondaryButtonText, for: .normal)
        configureSecondaryButtonStyle()
    }

    func configureCloseButton() {
        if viewModel?.overlayType == .fullScreen {
            let closeButtonImage = hasBackgroundImage ?
            VFGFoundationAsset.Image.icCloseWhite :
            VFGFoundationAsset.Image.icClose
            closeButton.setImage(closeButtonImage, for: .normal)
        } else if viewModel?.overlayType == .flexHeight {
            closeButton.isHidden = true
        }
    }

    func configureSecondaryButtonStyle() {
        if viewModel?.overlayType == .fullScreen {
            if hasBackgroundImage {
                secondaryButton.buttonStyle = 0
                secondaryButton.backgroundStyle = 1
            } else {
                secondaryButton.buttonStyle = 1
                secondaryButton.backgroundStyle = 0
            }
        } else if viewModel?.overlayType == .flexHeight {
            secondaryButton.buttonStyle = 2
            secondaryButton.backgroundStyle = 0
        }
    }
    /// Present flex height overlay using quick action controller
    public func presentFlexHeightOverlay() {
        guard viewModel?.overlayType == .flexHeight else { return }
        VFQuickActionsViewController.presentQuickActionsViewController(with: self)
    }

    @IBAction func closeButtonDidPress(_ sender: VFGButton) {
        dismiss(animated: true)
    }

    @IBAction func primaryButtonDidPress(_ sender: VFGButton) {
        viewModel?.primaryButtonCompletion?()
    }

    @IBAction func secondaryButtonDidPress(_ sender: VFGButton) {
        viewModel?.secondaryButtonCompletion?()
    }
}
/// View controller configuration with quick action for flex height overlay only
extension VFGOverlayViewController: VFQuickActionsModel {
    public var quickActionsTitle: String { "" }
    public var isCloseButtonHidden: Bool { true }
    public var upperCornersRadius: CGFloat { upperCornersRadiusConstant }
    public var quickActionsStyle: VFQuickActionsStyle { .white }
    public var quickActionsContentView: UIView {
        return view
    }
    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}
    public func closeQuickAction() {}
}
