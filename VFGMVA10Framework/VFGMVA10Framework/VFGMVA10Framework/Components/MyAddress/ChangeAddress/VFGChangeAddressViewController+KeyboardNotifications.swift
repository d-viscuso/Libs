//
//  VFGChangeAddressViewController+KeyboardNotifications.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/3/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - Keyboard Notification
extension VFGChangeAddressViewController {
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
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        guard scrollView.contentInset.bottom != 0 else { return }
        scrollView.contentInset.bottom = 0
    }
}
