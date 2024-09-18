//
//  VFGSwitchAccountViewController+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 21/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFGSwitchAccountViewController {
    func setupVoiceOverAccessibility() {
        accessibilityCustomActions = [cancelButtonVoiceOverAction()]
    }

    func cancelButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "cancel switch account action"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(cancelButtonAction)
        )
    }
}
