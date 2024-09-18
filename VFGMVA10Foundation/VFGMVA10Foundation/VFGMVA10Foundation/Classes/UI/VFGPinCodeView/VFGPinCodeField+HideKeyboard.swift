//
//  VFGPinCodeField+HideKeyboard.swift
//  VFGMVA10Foundation
//
//  Created by Ashraf Dewan on 29/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

extension VFGPinCodeField {
    func dismissKeyboardButton(title: String) {
        let toolbarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let doneToolbar = UIToolbar(frame: toolbarFrame)
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let done = UIBarButtonItem(
            title: title,
            style: .done,
            target: self,
            action: #selector(dismissKeyboardAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func dismissKeyboardAction() {
        self.resignFirstResponder()
    }
}
