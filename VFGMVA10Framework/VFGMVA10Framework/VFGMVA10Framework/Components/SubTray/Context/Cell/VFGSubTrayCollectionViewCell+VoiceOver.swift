//
//  VFGSubTrayCollectionViewCell+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFGSubTrayCollectionViewCell {
    func setupVoiceOverAccessibility() {
        recommendationView?.isAccessibilityElement = true
        imageView?.isAccessibilityElement = true
        defaultImageView?.isAccessibilityElement = true
        lockView?.isAccessibilityElement = true
        badgeView?.isAccessibilityElement = true
        recommendationView?.accessibilityLabel = "recommended banner"
        recommendationView?.accessibilityHint =
        "a banner which identify \(titleLabel?.text ?? "an item") as recommended"
        titleLabel?.accessibilityLabel = "subtray item title"
        titleLabel?.accessibilityValue = titleLabel?.text
        subtitleLabel?.accessibilityLabel = "subtray item subtitle"
        subtitleLabel?.accessibilityValue = subtitleLabel?.text
        descriptionLabel?.accessibilityLabel = "subtray item description"
        descriptionLabel?.accessibilityValue = descriptionLabel?.text
        imageView?.accessibilityLabel = "subtray item icon"
        lockView?.accessibilityLabel = "lock badge"
        lockView?.accessibilityHint =
        "a badge which indicates that you can't access \(titleLabel?.text ?? "an item") with current account"
        customizeButton?.accessibilityLabel = "customize subtray button"
        customizeButton?.accessibilityHint =
        "customize \(titleLabel?.text ?? "an item") name or set it as a default through dashboard"
        defaultImageView?.accessibilityLabel = "default icon"
        defaultImageView?.accessibilityHint =
        "\(titleLabel?.text ?? "an item") is set as default, you can see the usage data and balance through dashboard"
        badgeView?.accessibilityLabel = "notification badge"
        badgeView?.accessibilityValue = badgeView?.badgeModel?.text
        accessibilityCustomActions = [customizeButtonVoiceOverAction()]
    }

    func customizeButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "\(titleLabel?.text ?? "") subtray item customization action"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(customizeButtonAction)
        )
    }
}
