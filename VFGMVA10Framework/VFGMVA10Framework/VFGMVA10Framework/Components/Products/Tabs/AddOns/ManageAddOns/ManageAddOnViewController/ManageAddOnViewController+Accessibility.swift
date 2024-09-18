//
//  ManageAddOnViewController+Accessibility.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 18/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension ManageAddOnViewController {
    func setupAccessibilityIdentifier() {
        actionButton.accessibilityIdentifier = "ADremove"
        isRenewableSwitch.accessibilityIdentifier = "ADrenewToggle"
        addOnHeaderTitle.accessibilityIdentifier = "ADtitleLabel"
        priceDescLabel.accessibilityIdentifier = "ADpriceDescriptionLabel"
        priceLabel.accessibilityIdentifier = "ADpriceValueLabel"
        expirationDateLabel.accessibilityIdentifier = "ADexpiryLabel"
        autoRenewTitleLabel.accessibilityIdentifier = "ADautoRenewLabel"
    }

    func setupAccessibilityLabels() {
        expirationDateTitleLabel.accessibilityLabel = expirationDateTitleLabel.text
        addOnHeaderTitle.accessibilityLabel = addOnHeaderTitle.text
        priceDescLabel.accessibilityLabel = priceDescLabel.text
        priceLabel.accessibilityLabel = priceLabel.text
        autoRenewTitleLabel.accessibilityLabel = autoRenewTitleLabel.text
        expirationDateLabel.accessibilityLabel = expirationDateLabel.text
        showMoreButton.accessibilityLabel = showMoreButton.titleLabel?.text
        actionButton.accessibilityLabel = actionButton.titleLabel?.text
        addOnDesc.accessibilityLabel = addOnDesc.text
        accessibilityCustomActions = [showMoreVoiceOverAction()]
        accessibilityCustomActions?.append(actionButtonVoiceOverAction())
    }
    /// action for product AddOn  voice over
    /// - Returns: action for product AddOn  buttons in voice over
    func showMoreVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "showMore"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(showMoreButtonPressed))
    }

    func actionButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "actionButton"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(actionButtonPressed))
    }
}
