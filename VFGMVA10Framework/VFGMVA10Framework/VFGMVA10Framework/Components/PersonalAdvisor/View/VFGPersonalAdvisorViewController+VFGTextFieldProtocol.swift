//
//  VFGPersonalAdvisorViewController+VFGTextFieldProtocol.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 12/08/2022.
//

import VFGMVA10Foundation

extension VFGPersonalAdvisorViewController: VFGTextFieldProtocol {
    public func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) {
        vfgTextField.hideError()
        phoneNumberTextField.setErrorHintLabelAccessibilityLabel(with: phoneNumberTextField.textFieldErrorText)
    }
    public func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) {
        checkFrontendValidation(
            phoneNumber: phoneNumberTextField.textFieldText,
            description: descriptionTextView.text
        )
        phoneNumberTextField.setErrorHintLabelAccessibilityLabel(with: phoneNumberTextField.textFieldErrorText)
    }
    public func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        vfgTextField.hideError()
        checkFrontendValidation(
            phoneNumber: phoneNumberTextField.textFieldText,
            description: descriptionTextView.text
        )
        phoneNumberTextField.setErrorHintLabelAccessibilityLabel(with: phoneNumberTextField.textFieldErrorText)
    }
    public func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {
        //
    }
    func checkFrontendValidation(
        phoneNumber: String,
        description: String
    ) {
        confirmButton.isEnabled = false
        delegate?.validate(
            phoneNumber: phoneNumber,
            descriptionOfRequest: description
        ) { result in
            switch result {
            case .success:
                hideTextFieldsErrors()
                confirmButton.isEnabled = true
            case let .failed(errorMessage, textFieldType):
                confirmButton.isEnabled = false
                switch textFieldType {
                case nil:
                    hideTextFieldsErrors()
                case .phoneNumber:
                    phoneNumberTextField.showError(title: errorMessage)
                case .description:
                    showErrorTextView(descriptionTextView, title: errorMessage)
                }
            }
        }
        if descriptionTextView.textColor == .VFGSecondaryText {
            confirmButton.isEnabled = false
        }
    }
    private func hideTextFieldsErrors() {
        phoneNumberTextField.hideError()
        setUpDescriptionBottomText()
    }
    public func vfgTextFieldShouldReturn(_ vfgTextField: UITextField) -> Bool {
        vfgTextField.resignFirstResponder()
        return true
    }
}
