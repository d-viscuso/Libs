//
//  VFGPersonalAdvisorViewController+KeyboardNotifications.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 11/08/2022.
//

import UIKit

// MARK: - Keyboard Notification
extension VFGPersonalAdvisorViewController {
    func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            guard scrollView.contentInset.bottom == 0 else { return }
            self.scrollView.contentInset.bottom = keyboardSize.height
        }
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        guard scrollView.contentInset.bottom != 0 else { return }
        self.scrollView.contentInset.bottom = 0
    }
}
