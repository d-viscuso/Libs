//
//  VFGPersonalAdvisorViewController+UITextView.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 16/08/2022.
//

import UIKit

extension VFGPersonalAdvisorViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        setUpDescriptionBottomText()
        if textView.textColor == .VFGDefaultInputPlaceholderText {
            textView.text = ""
            textView.textColor = .VFGPrimaryText
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        checkFrontendValidation(
            phoneNumber: phoneNumberTextField.textFieldText,
            description: descriptionTextView.text
        )
    }
    public func textViewDidChange(_ textView: UITextView) {
        setUpDescriptionBottomText()
        checkFrontendValidation(
            phoneNumber: phoneNumberTextField.textFieldText,
            description: descriptionTextView.text
        )
    }
    public func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        // the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        // characters limit
        guard let descriptionMaxLength = delegate?.descriptionMaxLength else { return false }
        if updatedText.count > descriptionMaxLength {
            showErrorTextView(
                descriptionTextView,
                title: "personal_advisor_decription_max_limit".localized(bundle: .mva10Framework)
            )
        }
        return updatedText.count <= descriptionMaxLength
    }
    public func showErrorTextView(
        _ textView: UITextView,
        title: String? = nil
    ) {
        descriptionTipLabel.text = title
        descriptionTipLabel.textColor = .VFGErrorInputLabel
    }
}
