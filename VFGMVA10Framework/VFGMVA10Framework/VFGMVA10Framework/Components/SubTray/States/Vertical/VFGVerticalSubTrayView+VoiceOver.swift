//
//  VFGVerticalSubTrayView+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFGVerticalSubTrayView {
    func setupVoiceOverAccessibility() {
        subtitleLabel?.isAccessibilityElement = true
        searchTextField?.isAccessibilityElement = true
        subtitleLabel?.accessibilityLabel = "Subtray header title"
        subtitleLabel?.accessibilityValue = subtitleLabel?.text
        searchTextField?.accessibilityTraits = .searchField
        searchTextField?.accessibilityLabel = "Search text field"
    }
}
