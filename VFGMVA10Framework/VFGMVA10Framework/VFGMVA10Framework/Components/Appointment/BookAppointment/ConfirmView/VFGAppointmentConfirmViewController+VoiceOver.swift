//
//  VFGAppointmentConfirmViewController+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 21/04/2022.
//

import VFGMVA10Foundation

extension VFGAppointmentConfirmViewController {
    func addAccessibilityForVoiceOver() {
        closeButton?.accessibilityLabel = "close"
        accessibilityCustomActions = [closeVoiceOverAction()]
        accessibilityCustomActions?.append(addToCalendarVoiceOverAction())
        accessibilityCustomActions?.append(yourAppointmentVoiceOverAction())
    }
    /// action for book appointment voice over
    /// - Returns: action for book appointment  button in voice over
    func closeVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "close"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(closeAction))
    }
    func addToCalendarVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = calendarButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(addToCalendarAction))
    }
    func yourAppointmentVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = yourAppointmentButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(yourAppointmentAction))
    }
}
