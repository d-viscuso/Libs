//
//  VFGInitialTopUpView+TextField.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 13/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGInitialTopUpView: VFGTextFieldProtocol {
    func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) {}
    func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) {}
    func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {}

    func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        validateAmountTextField(text: text)
    }

    func configureTextField() {
        guard let viewModel = viewModel else { return }
        amountTextField.configureTextField(
            topTitleText: viewModel.textFieldUpperHint,
            placeHolder: viewModel.textFieldHint,
            isSecondaryPlaceholderEnabled: true,
            inputType: .numberPad,
            rightIcon: nil,
            tipText: viewModel.textFieldLowerHint
        )
        amountTextField.maxLength = viewModel.amountThreshold.toString()?.count
    }

    func validateAmountTextField(text: String) {
        if text.isEmpty {
            topupNowButton.isEnabled = false
            return
        }
        if checkIsAmountLeadingZeros(amount: text) {
            topupNowButton.isEnabled = false
            return
        }
        let amountInteger = Int(text) ?? 0
        if checkIsAmountExceedThreshold(amount: amountInteger) {
            topupNowButton.isEnabled = false
            textFieldCurrencyLabel.isHidden = true
            amountTextField.showError(
                title: viewModel?.textFieldErrorMessage ?? "",
                image: VFGFrameworkAsset.Image.icWarningNotificationUiredActive
            )
        } else {
            topupNowButton.isEnabled = true
            textFieldCurrencyLabel.isHidden = false
            amountTextField.hideError()
            configureTextField()
        }
    }

    func checkIsAmountLeadingZeros(amount: String) -> Bool {
        var flag = true
        let regex = #"^[1-9]\d*$"#
        if let amount = amount.matches(with: regex), !amount.isEmpty {
            flag = false
        }
        return flag
    }

    func checkIsAmountExceedThreshold(amount: Int) -> Bool {
        var flag = true
        if amount <= viewModel?.amountThreshold ?? 0 {
            flag = false
        }
        return flag
    }
}
