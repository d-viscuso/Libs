//
//  AddPaymentDetailsView+UITextField.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 10/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension AddPaymentDetailsView: VFGTextFieldProtocol {
    public func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) {
        switch vfgTextField {
        case cardNumberTextField:
            cardNumberTextField.hideError()
            cardNumberTextField.hideRightIcon()
            cardNumberTextField.getFocuesd()
            cardNumberTextFieldHeightConstraint.constant = defaultCardNumberViewHeight

        case cvvTextField:
            cvvTextField.hideError()
            cvvTextField.textFieldRightIcon = cvvIcon
            cvvTextField.getFocuesd()

        case expiryTextField:
            expiryTextField.hideError()
            expiryTextField.hideRightIcon()
            expiryTextField.getFocuesd()

        case nameOnCardTextField:
            nameOnCardTextField.hideError()
            nameOnCardTextField.hideRightIcon()
            nameOnCardTextField.getFocuesd()

        case cardNameTextField:
            cardNameTextField.hideError()
            cardNameTextField.hideRightIcon()
            cardNameTextField.getFocuesd()

        default:
            break
        }
    }

    public func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) {
        var text = vfgTextField.textFieldText
        switch vfgTextField {
        case cardNumberTextField:
            if !validateCardNumber(text) {
                cardNumberTextField.showRightIcon()
                cardNumberTextField.showError(title: cardNumberError, image: errorImage)
                cardNumberTextFieldHeightConstraint.constant = cardNumberViewHeightWithError
            }
        case cvvTextField:
            if !validateCvv(text) {
                cvvTextField.showError(title: cvvError)
            }
        case expiryTextField:
            if !validateExpiryDate(text) {
                expiryTextField.showRightIcon()
                expiryTextField.showError(title: expiryError, image: errorImage)
            }
        case nameOnCardTextField:
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !(AddPaymentDetailsView.creditCardValidator?.isValidNameOnCredit(text) ?? true) {
                nameOnCardTextField.showError()
                hasValidNameOnCard = false
            } else {
                hasValidNameOnCard = true
            }
        default:
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if AddPaymentDetailsView.creditCardValidator?.isValidCreditCardName(text) == false {
                cardNameTextField.showError()
                hasValidCardName = false
            } else {
                hasValidCardName = true
            }
        }

        delegate?.detailsDidChange()
    }

    public func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {}

    public func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        if vfgTextField.textFieldText.isEmpty {
            delegate?.cardNumberIsEmpty()
            return
        }
        switch vfgTextField {
        case cardNumberTextField:
            _ = validateCardNumber(vfgTextField.textFieldText)
        case cvvTextField:
            _ = validateCvv(vfgTextField.textFieldText)
        case expiryTextField:
            _ = validateExpiryDate(vfgTextField.textFieldText)
        case nameOnCardTextField:
            var text = vfgTextField.textFieldText
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !(AddPaymentDetailsView.creditCardValidator?.isValidNameOnCredit(text) ?? true) {
                hasValidNameOnCard = false
            } else {
                hasValidNameOnCard = true
            }
        case cardNameTextField:
            var text = vfgTextField.textFieldText
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !(AddPaymentDetailsView.creditCardValidator?.isValidNameOnCredit(text) ?? true) {
                hasValidCardName = false
            } else {
                hasValidCardName = true
            }
        default:
            break
        }

        delegate?.detailsDidChange()
    }

    public func vfgTextFieldShouldChange(
        _ vfgTextField: VFGTextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if vfgTextField == expiryTextField {
            let oldText = vfgTextField.textFieldText
            guard let oldRange = Range(range, in: oldText) else {
                return true
            }
            let updatedText = oldText.replacingCharacters(in: oldRange, with: string)

            if string.isEmpty {
                if updatedText.count == 2 {
                    vfgTextField.textFieldText = "\(updatedText.prefix(1))"
                    return false
                }
            } else if updatedText.count == 1 {
                if updatedText > "1" {
                    return false
                }
            } else if updatedText.count == 2 {
                if updatedText <= "12" { // Prevent user to not enter month more than 12
                    // This will add "/" when user enters 2nd digit of month
                    vfgTextField.textFieldText = "\(updatedText)/"
                }
                return false
            }
        } else if vfgTextField == nameOnCardTextField || vfgTextField == cardNameTextField {
            let range = string.rangeOfCharacter(from: .whitespaces)
            if (vfgTextField.textFieldText.isEmpty && range != nil)
                || ((vfgTextField.textFieldText.count) > 0 &&
                    vfgTextField.textFieldText.last == " " && range != nil) {
                return false
            }
        }
        return true
    }
}
