//
//  VFPermissionViewCard+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 03/04/2022.
//

import Foundation
extension VFPermissionViewCard {
    /// set accessibility for vocie over
    func setAccessibilityForVocieOver(isReadOnly: Bool = false) {
        cardTitle.accessibilityLabel = cardTitle.text
        cardText.accessibilityLabel = cardText.text
        toggleButton.accessibilityLabel = "toggle to turn off or on permission"
        var hint = ""
        if buttonToggledOn {
            hint = "permission is enabled, tap if you want to turn off permission"
        } else {
            hint = "permission is disabled, tap if you want to turn on permission"
        }
        toggleButton.accessibilityHint = hint
        self.accessibilityElements = [cardTitle, cardText].compactMap { $0 }
        if isReadOnly {
            statusLabel.accessibilityLabel = statusLabel.text
            icon.isAccessibilityElement = true
            icon.accessibilityLabel = "icon for \(cardTitle.text ?? "" )"
            let elements = [icon, requestTextView, statusLabel].compactMap { $0 }
            accessibilityElements?.append(contentsOf: elements)
        } else {
            guard let button = toggleButton else {
                return
            }
            accessibilityElements?.append(button)
            accessibilityCustomActions = [toggleVoiceAction()]
        }
    }
    /// action for toggle button in voice over
    /// - Returns: action for toggle button in voice over
    func toggleVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = buttonToggledOn ? "Turn off" : "Turn on"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(buttonToggleAction))
    }
}
