//
//  UIViewController+HideKeyboard.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 7/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension UIViewController {
    /// Adds *UITapGestureRecognizer* to current UIViewController's view to dismiss presented keyboard.
    public func addKeyboardDismissHandler() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(
                target: self,
                action: #selector(UIViewController.dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /// Dismisses keyboard presented on the current UIViewController.
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
}
