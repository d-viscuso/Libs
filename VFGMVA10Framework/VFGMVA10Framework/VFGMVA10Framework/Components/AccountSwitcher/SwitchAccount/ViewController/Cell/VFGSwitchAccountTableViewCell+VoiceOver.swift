//
//  VFGSwitchAccountTableViewCell+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 20/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFGSwitchAccountTableViewCell {
    func setupVoiceOverAccessibility() {
        iconImageView.isAccessibilityElement = true
        nameLabel.isAccessibilityElement = true
        accessoryImageView.isAccessibilityElement = true
        iconImageView.accessibilityLabel = "account icon"
        nameLabel.accessibilityLabel = "account name"
        nameLabel.accessibilityValue = nameLabel.text
        accessoryImageView.accessibilityLabel = "accessory icon"
        accessoryImageView.accessibilityValue = isSelectedAccount ? "tick icon" : "right arrow icon"
        accessoryImageView.accessibilityHint = isSelectedAccount ? "this account is selected" : ""
    }
}
