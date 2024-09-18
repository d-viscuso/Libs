//
//  StoryPreviewCell+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension StoryPreviewCell {
    func setupVoiceOverAccessibility() {
        guard let displayedStory = getDisplayedStory() else { return }
        imageView.accessibilityLabel = "\(displayedStory.title) story"
        videoView.accessibilityLabel = "\(displayedStory.title) story video"
        accessibilityCustomActions = []
        if !detailButton.isHidden {
            detailButton.accessibilityLabel = detailButton.titleLabel?.text
            accessibilityCustomActions?.append(detailsButtonVoiceOverAction())
        }
    }

    func detailsButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = detailButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(detailButtonAction)
        )
    }
}
