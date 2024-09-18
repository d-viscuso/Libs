//
//  VFGQuickActionsResultView.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 12/30/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import Lottie

public enum VFGResultViewMode {
    case fullScreen
    case quickAction
}

public enum VFGResultViewContentAlignment {
    case top
    case center
}

public class VFGResultView: VFGAnimatableView {
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var traceIDLabel: VFGLabel!
    @IBOutlet weak var traceIDContainerView: UIView!
    @IBOutlet weak var imageView: VFGImageView!
    @IBOutlet weak var secondaryButton: VFGButton!
    @IBOutlet weak var animationViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelCenterYConstraint: NSLayoutConstraint!

    weak var delegate: VFGResultViewProtocol?
    var animationLight: Animation?
    var animationDark: Animation?
    var animation: Animation? {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                return animationLight
            } else {
                return animationDark
            }
        }
        return animationLight
    }
    let topSpaceSmall: CGFloat = 32
    let topSpaceLarge: CGFloat = 167

    public func configure(
        model: VFGQuickActionsResultModel,
        accessibilityModel: VFGResultViewAccessibilityModel? = nil,
        accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel? = nil,
        style: VFGResultViewMode = .quickAction,
        contentAlignment: VFGResultViewContentAlignment = .top,
        backgroundColor: UIColor = .clear
    ) {
        delegate = model.delegate
        titleLabel.font = model.titleFont
        descriptionLabel.font = model.descriptionFont
        titleLabel.text = model.titleText
        descriptionLabel.text = model.descriptionText
        if let traceIDText = model.traceIDText {
            traceIDLabel.text = traceIDText
            traceIDContainerView.isHidden = false
        } else {
            traceIDContainerView.isHidden = true
            traceIDContainerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        primaryButton.setTitle(model.buttonTitle, for: .normal)
        primaryButton.titleLabel?.font = model.primaryButtonFont
        if let secondaryButtonTitle = model.secondaryButtonTitle {
            secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
            secondaryButton.titleLabel?.font = model.secondaryButtonFont
        } else {
            secondaryButton.isHidden = true
        }
        setupUIContent(with: model)
        switch contentAlignment {
        case .top:
            animationViewTopConstraint.isActive = true
            titleLabelCenterYConstraint.isActive = false
            animationViewTopConstraint.constant = style == .quickAction ? topSpaceSmall : topSpaceLarge
        case .center:
            titleLabelCenterYConstraint.isActive = true
            animationViewTopConstraint.isActive = false
        }
        self.backgroundColor = backgroundColor
        if let accessibilityModel = accessibilityModel {
            setupAccessibility(with: accessibilityModel)
        }
        if let accessibilityVoiceOverModel = accessibilityVoiceOverModel {
            setAccessibilityForVoiceOver(with: accessibilityVoiceOverModel)
        }
    }

    private func setupUIContent(with model: VFGQuickActionsResultModel) {
        switch model.type {
        case .success:
            animationLight = Animation.tickRed
            animationDark = Animation.tickWhite
            animationView.animation = animation
            imageView.isHidden = true
        case .failure:
            imageView.image = VFGFoundationAsset.Image.icWarningHiLightTheme
            animationView.isHidden = true
        case .customImage(let image):
            imageView.image = image
            animationView.isHidden = true
        case let .customAnimation(lightAnimation, darkAnimation):
            animationLight = lightAnimation
            animationDark = darkAnimation ?? lightAnimation
            animationView.animation = animation
            imageView.isHidden = true
        case .none:
            animationView.isHidden = true
            imageView.isHidden = true
        }
    }

    func setupAccessibility(with model: VFGResultViewAccessibilityModel) {
        titleLabel.accessibilityIdentifier = model.titleID
        descriptionLabel.accessibilityIdentifier = model.descriptionID
        imageView.accessibilityIdentifier = model.imageViewID
        animationView.accessibilityIdentifier = model.imageViewID
        primaryButton.accessibilityIdentifier = model.primaryButtonID
        secondaryButton.accessibilityIdentifier = model.secondaryButtonID
    }

    func setAccessibilityForVoiceOver(with model: VFGResultViewAccessibilityVoiceOverModel) {
        imageView.accessibilityLabel = model.imageViewLabel ?? ""
        animationView.accessibilityLabel = model.animationViewLabel ?? ""
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        primaryButton.accessibilityLabel = primaryButton.titleLabel?.text ?? ""
        secondaryButton.accessibilityLabel = secondaryButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [primaryButtonVoiceOverAction(), secondaryButtonVoiceOverAction()]
    }

    @IBAction func primaryButtonDidPress(_ sender: Any) {
        primaryButtonPressed()
    }
    @objc func primaryButtonPressed() {
        delegate?.resultViewPrimaryButtonAction()
    }
    func primaryButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = primaryButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(primaryButtonPressed))
    }

    @IBAction func secondaryButtonDidPress(_ sender: Any) {
        secondaryButtonPressed()
    }
    @objc func secondaryButtonPressed() {
        delegate?.resultViewSecondaryButtonAction()
    }
    func secondaryButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = secondaryButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(secondaryButtonPressed))
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(
                comparedTo: previousTraitCollection
            ) {
                animationView.animation = animation
                animationView.currentProgress = 1
            }
        }
    }
}
