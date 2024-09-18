//
//  VFGHorizontalSubTrayView+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFGHorizontalSubTrayView {
    func setupVoiceOverAccessibility() {
        subtitleLabel?.isAccessibilityElement = true
        subtitleLabel?.accessibilityLabel = "Subtray header title"
        subtitleLabel?.accessibilityValue = subtitleLabel?.text
    }
}
