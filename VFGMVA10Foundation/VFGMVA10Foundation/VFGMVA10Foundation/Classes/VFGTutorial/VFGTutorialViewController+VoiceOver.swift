//
//  VFGTutorialViewController+VoiceOver.swift
//  VFGMVA10Foundation
//
//  Created by Ramy Nasser on 03/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
// MARK: Voice over
extension VFGTutorialViewController {
    /// Add accessibility for voice over
    func addAccessibilityForVoiceOver() {
        animationView.accessibilityLabel = "image for tutorial"
        pageControl.accessibilityLabel = "horizontal scroller to navigate through the available tutorials"
        itemsStackView.shouldGroupAccessibilityChildren = true
        accessibilityCustomActions = [primaryVoiceOverAction(), secondaryVoiceOverAction()]
    }
    /// action for agree button in voice over
    /// - Returns: action for primary button in voice over
    func primaryVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = primaryButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(primaryButtonAction))
    }
    /// action for continue button  in voice over
    /// - Returns: action for secondary button in voice over
    func secondaryVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = secondaryButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(secondaryButtonAction))
    }
}
