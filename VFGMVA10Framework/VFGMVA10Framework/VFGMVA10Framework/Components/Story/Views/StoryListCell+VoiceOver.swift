//
//  StoryListCell+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension StoryCardCell {
    func setupVoiceOverAccessibility() {
        storyImageView.accessibilityLabel = "story thumbnail"
        storyImageView.accessibilityValue = titleLabel.text
        titleLabel.accessibilityLabel = "story title"
        titleLabel.accessibilityValue = titleLabel.text
        accessibilityElements = [
            storyImageView,
            countdownLabel,
            titleLabel
        ].compactMap { $0 }
    }
}

extension StoryCircleCell {
    func setupVoiceOverAccessibility() {
        storyImageView?.accessibilityLabel = "story thumbnail"
        storyImageView?.accessibilityValue = titleLabel?.text
        titleLabel?.accessibilityLabel = "story title"
        titleLabel?.accessibilityValue = titleLabel?.text
        accessibilityElements = [
            storyImageView,
            countdownLabel,
            titleLabel
        ].compactMap { $0 }
    }
}
