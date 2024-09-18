//
//  VFGYourAppointmentsViewController+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 20/04/2022.
//

import VFGMVA10Foundation

extension VFGYourAppointmentsViewController {
    func addAccessibilityForVoiceOver() {
        mva10navigationController?.setAccessibilityLabels(closeButtonLabel: "close", backButtonLabel: "back")
        sectionTitleLabel.accessibilityLabel = sectionTitleLabel.text
        accessibilityCustomActions = [bookAppointmentVoiceOverAction()]
    }
    /// action for book appointment voice over
    /// - Returns: action for book appointment  button in voice over
    func bookAppointmentVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = bookAppointmentButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(bookAppointmentAction))
    }
}
