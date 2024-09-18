//
//  VFGAppointmentsCollectionViewCell+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 21/04/2022.
//

import VFGMVA10Foundation
// MARK: Voice Over
extension VFGAppointmentsCollectionViewCell {
    func addAccessibilityForVoiceOver() {
        accessibilityCustomActions = [cancelVoiceOverAction()]
        accessibilityCustomActions?.append(changeBookVoiceOverAction())
        accessibilityCustomActions?.append(storeLocationVoiceOverAction())
    }
    /// action for cancel appointment voice over
    /// - Returns: action for cancel appointment button in voice over
    func cancelVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = cancelButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(cancelButtonAction))
    }
    /// action for store location voice over
    /// - Returns: action for get store location  button in voice over
    func storeLocationVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = getStoreDirectionButton.titleLabel?.text ?? ""
        let selector = #selector(storeLocationButtonAction)
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: selector)
    }
    /// action for store location voice over
    /// - Returns: action for get store location  button in voice over
    func changeBookVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = changeBookingButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(changeBookAction))
    }
}
