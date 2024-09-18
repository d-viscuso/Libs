//
//  VFGPinCodeView+UITextField.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Kishk on 11/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

// MARK: - TextField Methods -
extension VFGPinCodeView: UITextFieldDelegate {
    func textFieldDidBeginEditingImpl(_ textField: UITextField) {
        checkPlaceHolder(textField)

        if let containerView = textField.superview?.viewWithTag(51) {
            selectedTextField = textField
            self.stylePinField(containerView: containerView, isActive: true)
        } else { showPinError(error: "ERR-106: Type Mismatch") }
    }

    private func checkPlaceHolder(_ textField: UITextField) {
        guard let placeholderLabel = textField.superview?.viewWithTag(400) as? UILabel else {
            showPinError(error: "ERR-105: Type Mismatch")
            return
        }
        placeholderLabel.isHidden = true
        let text = textField.text ?? ""
        if text.isEmpty {
            textField.isSecureTextEntry = false
            placeholderLabel.isHidden = false
        } else if deleteButtonAction == .moveToPreviousAndDelete ||
            deleteButtonAction == .deleteCurrentAndMoveToPrevious {
            textField.text = ""
            let passwordIndex = (textField.tag - 100) - 1
            if password.count > (passwordIndex) {
                password[passwordIndex] = ""
                textField.isSecureTextEntry = false
                placeholderLabel.isHidden = false
                didChangeCallback?(password.joined())
            }
        }
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidBeginEditingImpl(textField)
        textField.accessibilityHint = "Current selected pin field"
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let containerView = textField.superview?.viewWithTag(51) {
            self.stylePinField(containerView: containerView, isActive: false)
            updateAccessibilityHint(for: textField)
        } else { showPinError(error: "ERR-107: Type Mismatch") }
    }

    func updateAccessibilityHint(for textField: UITextField) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            textField.accessibilityHint = ""
        } else {
            textField.accessibilityHint = "with secured code entered"
        }
    }

    func textFieldDidChange(_ textField: UITextField) {
        handleErrorState()
        var nextTag = textField.tag
        let index = nextTag - 100
        guard let placeholderLabel = textField.superview?.viewWithTag(400) as? UILabel else {
            showPinError(error: "ERR-101: Type Mismatch")
            return
        }

        // ensure single character in text box and trim spaces
        if textField.text?.count ?? 0 > 1 {
            textField.text?.removeFirst()
            textField.text = { () -> String in
                let text = textField.text ?? ""
                return String(text[..<text.index((text.startIndex), offsetBy: 1)])
            }()
        }

        let isBackSpace = { () -> Bool in
            guard let char = textField.text?.cString(using: String.Encoding.utf8) else { return false }
            return strcmp(char, "\\b") == -92
        }

        if !self.allowsWhitespaces && !isBackSpace() &&
            (textField.text?.trimmingCharacters(
                in: .whitespacesAndNewlines) ?? "").isEmpty {
            return
        }

        // if entered text is a backspace - do nothing; else - move to next field
        // backspace logic handled in VFGPinCodeField
        nextTag = isBackSpace() ? textField.tag : textField.tag + 1

        // Try to find next responder
        if let nextResponder = textField.superview?.superview?.superview?.superview?.viewWithTag(nextTag)
            as UIResponder? {
            // Found next responder, so set it.
            nextResponder.becomeFirstResponder()
        } else {
            // Not found, so dismiss keyboard
            if index == 1 && shouldDismissKeyboardOnEmptyFirstField {
                textField.resignFirstResponder()
            } else if index > 1 { textField.resignFirstResponder() }
        }

        // activate the placeholder if textField empty
        placeholderLabel.isHidden = !(textField.text?.isEmpty ?? true)

        // secure text after a bit
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(secureTextDelay)) {
            if !(textField.text?.isEmpty ?? true) {
                placeholderLabel.isHidden = true
                if self.shouldSecureText { textField.text = self.secureCharacter }
            }
        }

        // store text
        let text = textField.text ?? ""
        let passwordIndex = index - 1
        if password.count > (passwordIndex) {
            // delete if space
            password[passwordIndex] = text
        } else {
            password.append(text)
        }
        validateAndSendCallback()
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        var isEqualToPasteBoardString = false
        if #available(iOS 16, *) {
            isEqualToPasteBoardString = false
        } else {
            isEqualToPasteBoardString = string == UIPasteboard.general.string
        }
        if (string.count >= pinLength) && (isEqualToPasteBoardString || isContentTypeOneTimeCode) {
            textField.resignFirstResponder()
            DispatchQueue.main.async { self.pastePin(pin: string) }
            return false
        } else if let cursorLocation = textField.position(
            from: textField.beginningOfDocument,
                offset: (range.location + string.count)),
                cursorLocation == textField.endOfDocument {
            // If the user moves the cursor to the beginning of the field, move it to the end before textEntry,
            // so the oldest digit is removed in textFieldDidChange: to ensure single character entry
            textField.selectedTextRange = textField.textRange(from: cursorLocation, to: textField.beginningOfDocument)
        }
        return true
    }
}
