//
//  VFGPinCodeView+StylePin.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 11/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension VFGPinCodeView {
    // MARK: - Public methods -

    /// Returns the entered PIN; returns empty string if incomplete
    /// - Returns: The entered PIN.

    public func getPin() -> String {
        guard !isLoading else { return "" }
        guard password.count == pinLength && password.joined().trimmingCharacters(
            in: CharacterSet(charactersIn: " ")
        ).count == pinLength else {
            return ""
        }
        return password.joined()
    }

    /// Clears the entered PIN and refreshes the view
    /// - Parameter completionHandler: Called after the pin is cleared the view is re-rendered.

    public func clearPin(completionHandler: (() -> Void)? = nil) {
        guard !isLoading else { return }

        password.removeAll()
        refreshPinView(completionHandler: completionHandler)
    }

    /// Clears the entered PIN and refreshes the view.
    /// (internally calls the clearPin method; re-declared since the name is more intuitive)
    /// - Parameter completionHandler: Called after the pin is cleared the view is re-rendered.
    public func refreshView(completionHandler: (() -> Void)? = nil) {
        clearPin(completionHandler: completionHandler)
    }

    /// Pastes the PIN onto the PinView
    /// - Parameter pin: The pin which is to be entered onto the PinView.
    public func pastePin(pin: String) {
        password = []
        for (index, char) in pin.enumerated() {
            guard index < pinLength else { return }

            // Get the first textField
            guard let textField = collectionView.cellForItem(
            at: IndexPath(
            item: index,
            section: 0))?
            .viewWithTag(101 + index) as? VFGPinCodeField,
        let placeholderLabel = collectionView.cellForItem(
            at: IndexPath(item: index, section: 0))?
            .viewWithTag(400) as? UILabel
            else {
                showPinError(error: "ERR-103: Type Mismatch")
                return
            }

            textField.text = String(char)
            placeholderLabel.isHidden = true

            // secure text after a bit
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(secureTextDelay)) {
                if !(textField.text ?? "").isEmpty {
                    if self.shouldSecureText { textField.text = self.secureCharacter }
                }
            }

            // store text
            password.append(String(char))
            validateAndSendCallback()
        }
    }
}
