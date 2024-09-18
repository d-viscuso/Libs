//
//  StoryPreviewHeaderView+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension StoryPreviewHeaderView {
    func setupVoiceOverAccessibility() {
        titleLabel.accessibilityLabel = "story title"
        titleLabel.accessibilityValue = titleLabel.text
        descriptionLabel.accessibilityLabel = "story description"
        descriptionLabel.accessibilityValue = descriptionLabel.text
        iconImageView.accessibilityLabel = "story icon"
        progressContainerView.accessibilityLabel = "progress indicator"
        closeButton.accessibilityLabel = "close story"
        accessibilityCustomActions = [closeButtonVoiceOverAction()]
    }

    func closeButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "close action"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(closeButtonAction)
        )
    }
}
