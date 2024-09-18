//
//  VFGChangePasswordViewController+VFGTextFieldProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 12/29/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGChangePasswordViewController: VFGTextFieldProtocol {
    public func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) {
        vfgTextField.hideError()
        updateStrengthPosition()
        updateForgotPasswordPosition()
        confirmPasswordTextField.setErrorHintLabelAccessibilityLabel(with: confirmPasswordTextField.textFieldErrorText)
    }

    public func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) {
        validationTimer.invalidate()
        checkFrontendValidation(
            currentPassword: currentPasswordTextField.textFieldText,
            newPassword: newPasswordTextField.textFieldText,
            confirmedPassword: confirmPasswordTextField.textFieldText
        )
        confirmPasswordTextField.setErrorHintLabelAccessibilityLabel(with: confirmPasswordTextField.textFieldErrorText)
    }

    public func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        vfgTextField.hideError()
        updateStrengthPosition()
        updateForgotPasswordPosition()
        checkPasswordRules(newPasswordTextField.textFieldText)
        validationTimer.invalidate()
        validationTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.validationDelay,
            repeats: false
        ) { [weak self] timer in
            guard let self = self else { return }
            timer.invalidate()
            self.checkFrontendValidation(
                currentPassword: self.currentPasswordTextField.textFieldText,
                newPassword: self.newPasswordTextField.textFieldText,
                confirmedPassword: self.confirmPasswordTextField.textFieldText
            )
        }
        updatePasswordStrength(self.newPasswordTextField.textFieldText)
        confirmPasswordTextField.setErrorHintLabelAccessibilityLabel(with: confirmPasswordTextField.textFieldErrorText)
    }

    public func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {
        let iconImage = vfgTextField.isSecureTextEntry ? UIImage.VFGPassword.hide : UIImage.VFGPassword.show
        let hintText = vfgTextField.isSecureTextEntry ? "Hide entered password" : "Show entered password"
        vfgTextField.isSecureTextEntry.toggle()
        vfgTextField.textFieldRightIcon = iconImage
        vfgTextField.setRightButtonAccessibilityHint(with: hintText)
    }

    func checkFrontendValidation(
        currentPassword: String,
        newPassword: String,
        confirmedPassword: String
    ) {
        confirmButton.isEnabled = false
        delegate?.validate(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmedPassword: confirmedPassword
        ) { result in
            switch result {
            case .success:
                hideTextFieldsErrors()
                confirmButton.isEnabled = checkPasswordRules(newPassword)
            case let .failed(errorMessage, textFieldType):
                confirmButton.isEnabled = false
                switch textFieldType {
                case nil:
                    hideTextFieldsErrors()
                case .current:
                    currentPasswordTextField.showError(title: errorMessage)
                case .new:
                    newPasswordTextField.showError(title: errorMessage)
                case .confirm:
                    confirmPasswordTextField.showError(title: errorMessage)
                }
            }
            updateStrengthPosition()
            updateForgotPasswordPosition()
            checkAccessibilityCustomActions()
        }
    }

    private func hideTextFieldsErrors() {
        textFields.forEach {
            $0.hideError(resetBorderColor: !$0.isTextFieldFocused)
        }
    }

    private func updatePasswordStrength(_ password: String) {
        guard let strengthOf = delegate?.strength, let strength = strengthOf(password) else {
            return
        }
        enabledPasswordStrengthBoxesCount = strength.rawValue
        switch enabledPasswordStrengthBoxesCount {
        case 1...3:
            strengthLabel?.text = "change_password_strength_weak_title".localized(bundle: .mva10Framework)
        case 4...5:
            strengthLabel?.text = "change_password_strength_normal_title".localized(bundle: .mva10Framework)
        case 6...7:
            strengthLabel?.text = "change_password_strength_strong_title".localized(bundle: .mva10Framework)
        default:
            strengthLabel?.text = "change_password_strength_title".localized(bundle: .mva10Framework)
        }
        strengthLabel?.accessibilityLabel = strengthLabel?.text
    }

    public func vfgTextFieldShouldReturn(_ vfgTextField: VFGTextField) -> Bool {
        vfgTextField.resignFirstResponder()
        return true
    }
}
