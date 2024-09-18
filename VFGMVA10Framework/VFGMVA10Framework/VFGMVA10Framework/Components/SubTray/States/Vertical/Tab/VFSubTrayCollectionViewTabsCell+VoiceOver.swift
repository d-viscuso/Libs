//
//  VFSubTrayCollectionViewTabsCell+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFSubTrayCollectionViewTabsCell {
    func setupVoiceOverAccessibility() {
        tabTitle.isAccessibilityElement = true
        tabUnderline.isAccessibilityElement = true
        tabTitle.accessibilityLabel = "tab title"
        tabTitle.accessibilityValue = tabTitle.text
        tabUnderline.accessibilityLabel = "tab underline"
        tabUnderline.accessibilityHint = "it indicates if the tab is selected or not"
    }
}
