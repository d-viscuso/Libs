//
//  VFGPageBanner.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 8/31/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// A banner which appear below the header on second level pages and can contains any information pertinent to the user.
public class VFGPageBanner: UIView {
    // MARK: Views
    @IBOutlet public weak var headerLabel: VFGLabel!
    @IBOutlet public weak var switchButton: VFGSwitch!
    @IBOutlet public weak var headerImageView: VFGImageView!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet public weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var secondaryButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondaryButtonToViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var primaryButtonToViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var primaryToSecondaryConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerImageToHeaderLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLabelToCloseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLabelToSwitchButtonConstraint: NSLayoutConstraint!
    let topBottomInsets: CGFloat = 8
    let leftRightInsets: CGFloat = 16
    /// A delegate that is called when clicking on page banner's buttons
    public weak var delegate: VFGPageBannerProtocol?
    /// A delegate that is called when page banner is dismissed
    public weak var myPlanDelegate: VFGPageBannerDismissProtocol?
    // Default Button Colors
    private let buttonBackgroundDefaultColor = UIColor.clear
    private let buttonBorderDefaultColor = UIColor.VFGSecondaryButtonActiveOutlineDarkBG
    private let buttonTitleDefaultColor = UIColor.VFGSecondaryButtonActiveTextDarkBG

    // MARK: actions
    @IBAction func closeBanner(_ sender: VFGButton) {
        closeButtonPressed()
    }
    @objc func closeButtonPressed() {
        myPlanDelegate?.dismissBanner()
    }
    func closeButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = "Close"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(closeButtonPressed)
        )
    }

    @IBAction func primaryButtonAction(_ sender: VFGButton) {
        primaryButtonPressed()
    }
    @objc func primaryButtonPressed() {
        delegate?.primaryButtonDidSelect(for: self)
    }
    func primaryButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = primaryButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(primaryButtonPressed)
        )
    }

    @IBAction func secondaryButtonAction(_ sender: VFGButton) {
        secondaryButtonPressed()
    }
    @objc func secondaryButtonPressed() {
        delegate?.secondaryButtonDidSelect(for: self)
    }
    func secondaryButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = secondaryButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(secondaryButtonPressed)
        )
    }

    @IBAction func switchButtonAction(_ sender: VFGSwitch) {
        switchButtonPressed()
    }
    @objc func switchButtonPressed() {
        delegate?.switchButtonDidSelect(for: self)
        switchButtonVoiceoverSetup()
        accessibilityCustomActions?.removeLast()
        accessibilityCustomActions?.append(switchButtonVoiceAction())
    }
    func switchButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = switchButton.isOn ? "Turn off" : "Turn on"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(switchButtonPressed)
        )
    }
    // MARK: setup UI
    public func setupUI(model: VFGPageBannerModel, imageDescription: String? = nil) {
        headerLabel.text = model.header
        headerLabel.textColor = model.headerTextColor
        descriptionLabel.text = model.description
        descriptionLabel.textColor = model.descriptionTextColor
        headerImageView.image = model.image
        if let image = model.image {
            headerImageView.image = image
        } else {
            headerImageView.isHidden = true
            headerImageWidthConstraint.constant = 0
            headerImageToHeaderLabelConstraint.constant = 0
        }
        setupPrimaryButton(with: model)
        setupSecondaryButton(with: model)

        switch model.buttonType {
        case .none:
            switchButton.isHidden = true
            closeButton.isHidden = true
            headerLabelToSwitchButtonConstraint.isActive = false
        case .toggle(let isOn):
            switchButton.isOn = isOn
            switchButton.isHidden = false
            closeButton.isHidden = true
            headerLabelToCloseButtonConstraint.isActive = false
        case .close:
            switchButton.isHidden = true
            closeButton.isHidden = false
            headerLabelToSwitchButtonConstraint.isActive = false
        }

        if model.backgroundColors.count == 1, let backgroundColor = model.backgroundColors.first {
            self.backgroundView.backgroundColor = UIColor(cgColor: backgroundColor)
        } else {
            backgroundView.setGradientBackgroundColor(
                colors: model.backgroundColors,
                startPoint: CGPoint(x: 1, y: 0),
                endPoint: CGPoint(x: 0, y: 0))
        }
        setupAccessibilityLabels()
        setupAccessibilityVoiceover(with: imageDescription)
    }
    func setupAccessibilityVoiceover(with imageDescription: String?) {
        accessibilityCustomActions = []
        if !headerImageView.isHidden && imageDescription != nil {
            headerImageView.accessibilityLabel = imageDescription
        }
        headerLabel.accessibilityLabel = headerLabel.text ?? ""
        if !closeButton.isHidden {
            closeButton.accessibilityLabel = "Close"
            accessibilityCustomActions?.append(closeButtonVoiceAction())
        }
        descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        primaryButton.accessibilityLabel = primaryButton.titleLabel?.text ?? ""
        accessibilityCustomActions?.append(primaryButtonVoiceAction())
        if !secondaryButton.isHidden {
            secondaryButton.accessibilityLabel = secondaryButton.titleLabel?.text ?? ""
            accessibilityCustomActions?.append(secondaryButtonVoiceAction())
        }
        if !switchButton.isHidden {
            switchButtonVoiceoverSetup()
            accessibilityCustomActions?.append(switchButtonVoiceAction())
        }
    }
    func switchButtonVoiceoverSetup() {
        var label = ""
        var hint = ""
        if switchButton.isOn {
            label = "Toggled on"
            hint = "Tap if you want to turn off"
        } else {
            label = "Toggled off"
            hint = "Tap if you want to turn on"
        }
        switchButton.accessibilityLabel = label
        switchButton.accessibilityHint = hint
    }

    private func setupPrimaryButton(with model: VFGPageBannerModel) {
        primaryButton.setTitle(model.primaryButton, for: .normal)
        primaryButton.backgroundColor = model.primaryButtonBackgroundColor ?? buttonBackgroundDefaultColor
        primaryButton.borderColor = model.primaryButtonBorderColor ?? buttonBorderDefaultColor
        primaryButton.setTitleColor(model.primaryButtonTitleColor ?? buttonTitleDefaultColor, for: .normal)
        primaryButton.contentEdgeInsets = UIEdgeInsets(
            top: topBottomInsets,
            left: leftRightInsets,
            bottom: topBottomInsets,
            right: leftRightInsets
        )
    }

    private func setupSecondaryButton(with model: VFGPageBannerModel) {
        secondaryButton.setTitle(model.secondaryButton, for: .normal)
        secondaryButton.backgroundColor = model.secondaryButtonBackgroundColor ?? buttonBackgroundDefaultColor
        secondaryButton.borderColor = model.secondaryButtonBorderColor ?? buttonBorderDefaultColor
        secondaryButton.setTitleColor(model.secondaryButtonTitleColor ?? buttonTitleDefaultColor, for: .normal)
        secondaryButton.contentEdgeInsets = UIEdgeInsets(
            top: topBottomInsets,
            left: leftRightInsets,
            bottom: topBottomInsets,
            right: leftRightInsets
        )

        if model.secondaryButton.isEmptyOrNil {
            secondaryButton.isHidden = true
            // Apply default style if no custom colors provided
            if model.primaryButtonTitleColor == nil,
                model.primaryButtonBackgroundColor == nil,
                model.primaryButtonBorderColor == nil {
                primaryButton.buttonStyle = 1
            }
            secondaryButtonWidthConstraint.isActive = false
            secondaryButtonToViewConstraint.isActive = false
            primaryToSecondaryConstraint.priority = .defaultLow
            primaryButtonToViewConstraint.priority = .defaultHigh
        }
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        CATransaction.withDisabledActions { [weak self] in
            guard let self = self else { return }
            self.backgroundView?.layer.sublayers?.first?.frame = self.backgroundView.bounds
        }
    }

    private func setupAccessibilityLabels() {
        closeButton.isAccessibilityElement = true
        closeButton.accessibilityLabel = "Close"
    }
}
