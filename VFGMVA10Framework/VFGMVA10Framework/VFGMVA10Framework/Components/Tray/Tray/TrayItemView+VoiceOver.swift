//
//  TrayItemView+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension TrayItemView {
    func setupVoiceOverAccessibility() {
        iconImageView.isAccessibilityElement = true
        iconImageView.accessibilityLabel = "tray item icon"
        itemTitleLabel.accessibilityLabel = "tray item label"
        itemTitleLabel.accessibilityValue = itemTitleLabel.text
        button.accessibilityLabel = "\(itemTitleLabel.text ?? "") tray item action"
        button.accessibilityHint = isLastSelectedItem ?
        "\(itemTitleLabel.text ?? "") tray item is selected right now" : ""
        accessibilityElements = [iconImageView, itemTitleLabel, button].compactMap { $0 }
        accessibilityCustomActions = [trayItemVoiceOverAction()]
    }

    func trayItemVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "\(itemTitleLabel.text ?? "") tray item action"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(trayItemAction)
        )
    }
}
