//
//  VFGTextField+TextFieldDelegates.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 8/24/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

extension VFGTextField: VFGGenericTextFieldProtocol {
    // MARK: - textFieldDelegate
    ///
    public override var inputView: UIView? {
        textFieldView?.textField.inputView
    }
    /// Handle configurations for *VFGTextField* when user begin typing in text field
    /// - Parameters:
    ///    - textField: Text field where user type text
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if isOptionsPickerTextField {
            delegate?.vfgTextFieldDidBeginEditing(self)
            return
        }
        isTextFieldFocused = true
        var textFieldLeadingConstraint: CGFloat = textFieldLeadingDefault
        if textFieldView?.countryCodeLabelWidthConstraint.constant != 0 {
            textFieldLeadingConstraint =
                textFieldLeadingDefault + 6 + (textFieldView?.countryCodeLabelWidthConstraint.constant ?? 0)
        }
        textFieldView?.textFieldLeadingConstraints.constant = textFieldLeadingConstraint

        if textField.text?.isEmpty ?? false {
            textFieldView?.textField.placeholder = self.secondaryPlaceholderText
        } else {
            textFieldView?.textField.placeholder = ""
        }

        textFieldView?.changeBorderState(to: .focus)

        delegate?.vfgTextFieldDidBeginEditing(self)
    }
    /// Handle configurations for *VFGTextField* when user end typing in text field
    /// - Parameters:
    ///    - textField: Text field where user type text
    public func textFieldDidEndEditing(_ textField: UITextField) {
        isTextFieldFocused = false
        if isOptionsPickerTextField { return }
        delegate?.vfgTextFieldDidEndEditing(self)
        if textFieldText.isEmpty {
            resetTextField()
        } else if !hasError {
            textFieldView?.changeBorderState(to: .full)
        }
    }
    /// Set text field to its default values
    public func resetTextField() {
        textFieldText = ""
        var textFieldLeadingConstraint: CGFloat = 14
        if textFieldView?.countryCodeLabelWidthConstraint.constant != 0 {
            textFieldLeadingConstraint =
                textFieldLeadingDefault + 6 + (textFieldView?.countryCodeLabelWidthConstraint.constant ?? 0)
        }
        textFieldView?.textFieldLeadingConstraints.constant = textFieldLeadingConstraint
        textFieldView?.textField.placeholder = textFieldHintText
        textFieldView?.changeBorderState(to: .normal)
    }
    /// Check characters validations and max number of character allowed in text field
    /// - Parameters:
    ///    - textField: The text field containing the text
    ///    - range: The range of characters to be replaced
    ///    - string: The replacement string for the specified range
    /// - Returns: True if entered text matches required validations and false if not
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if isOptionsPickerTextField {
            return false
        }
        // Allowed Characters Validation
        if let allowedCharacters = allowedCharacters {
            let allowedCharacters = CharacterSet(charactersIn: allowedCharacters)
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
        }

        // Not Allowed Characters Validation
        if let notAllowedCharacters = notAllowedCharacters {
            let notAllowedCharacters = CharacterSet(charactersIn: notAllowedCharacters)
            let characterSet = CharacterSet(charactersIn: string)
            if notAllowedCharacters.isSuperset(of: characterSet),
            !string.isEmpty { // Allow backspace
                return false
            }
        }

        // Max Length Validation
        if let maxLength = maxLength {
            if !isValidLength(textField: textField, range: range, string: string, maxLength: maxLength) {
                return false
            }
        }
        return delegate?.vfgTextFieldShouldChange(
            self,
            shouldChangeCharactersIn: range,
            replacementString: string
            ) ?? true
    }
    /// Determine whether to begin editing in the specified text field
    /// - Parameters:
    ///    - textField: The text field containing the text
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.vfgTextFieldShouldBeginEditing(textField) ?? true
    }
    /// Determine whether to stop editing in the specified text field or not
    /// - Parameters:
    ///    - textField: The text field containing the text
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.vfgTextFieldShouldEndEditing(textField) ?? true
    }
    /// Handle text field place holder text when the text selection changes in the specified text field
    /// - Parameters:
    ///    - textField: The text field containing the text
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty ?? false {
            textFieldView?.textField.placeholder = self.secondaryPlaceholderText
        } else {
            textFieldView?.textField.placeholder = ""
        }
        delegate?.vfgTextFieldDidChangeSelection(textField)
    }
    /// Determine whether to remove the text field’s current contents or not
    /// - Parameters:
    ///    - textField: The text field containing the text
    /// - Returns: True if text field should be cleared and false if not
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.vfgTextFieldShouldClear(textField) ?? false
    }
    /// Determine whether to process the pressing of the return button for the text field or not
    /// - Parameters:
    ///    - textField: The text field containing the text
    /// - Returns: True if return button action process will happen and false if not
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.vfgTextFieldShouldReturn(textField) ?? false
    }

    func isValidLength(
        textField: UITextField,
        range: NSRange,
        string: String,
        maxLength: Int
    ) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= maxLength
    }

    func vfgTextFieldRightButtonClicked(_ textField: VFGGenericTextField) {
        delegate?.vfgTextFieldRightButtonClicked(self)
    }

    func vfgTextFieldTextChange(_ textField: VFGGenericTextField, text: String) {
        if isOptionsPickerTextField { return }
        textFieldView?.changeBorderState(to: .focus)
        if textFieldView?.counterView.isHidden == false {
            textFieldView?.updateCounterCurrentValue(textFieldText.count)
        }
        delegate?.vfgTextFieldDidChange(self, text: textFieldText)
    }

    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        textFieldView?.becomeFirstResponder() ?? super.becomeFirstResponder()
    }
}
