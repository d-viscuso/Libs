//
//  VFGTextField+ConfigureTextField.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 6/30/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGTextField {
    /**
    Configure textfield

    - Parameter topTitleText: Top text title
    - Parameter placeHolder: Primary placeholder of textfield and it move to the top when starts typing
    - Parameter secondaryPlaceholder: The textfield placeholder that shown only when user starts typing and the primary placeholder move to the top
    - Parameter isSecondaryPlaceholderEnabled: A `Boolean` indicating if show or hide `secondaryPlaceholder`
    - Parameter inputType: The type of keyboard to display for a text-based view.
    - Parameter rightIcon: The icon to the right of textfield
    - Parameter secureTextEntry: A `Boolean` indicating if textfield value will be shown as dots like password textfield
    - Parameter hasCountryCode: A `Boolean` indicating if country code will be shown at the beginning of textfield
    - Parameter countryCode: The country phone code shown at the beginning of textfield
    - Parameter tipText: The text shown below textfield view
    - Parameter inputView: Source view that provides values to the textfield e.g. Picker view
    */
    public func configureTextField(
        topTitleText: String? = nil,
        placeHolder: String? = nil,
        placeHolderColor: UIColor = UIColor.VFGDefaultInputPlaceholderText,
        secondaryPlaceholder: String? = nil,
        isSecondaryPlaceholderEnabled: Bool? = false,
        inputType: UIKeyboardType? = nil,
        rightIcon: UIImage? = nil,
        secureTextEntry: Bool? = false,
        hasCountryCode: Bool? = false,
        countryCode: String? = nil,
        tipText: String? = nil,
        inputView: UIView? = nil,
        textContentType: UITextContentType? = nil,
        counterMaxLength: Int? = nil
    ) {
        let phoneCountryCode = "(+356)"

        if topTitleText != nil {
            textFieldTopTitleText = topTitleText ?? ""
        }
        if secondaryPlaceholder != nil, isSecondaryPlaceholderEnabled ?? false {
            textFieldSecondaryPlaceholderText = secondaryPlaceholder ?? ""
        }
        self.placeHolderColor = placeHolderColor
        if placeHolder != nil {
            textFieldPlaceHolderText = placeHolder ?? ""
        }
        if inputType != nil {
            textFieldKeyboardType = inputType ?? .default
        }
        textFieldView?.rightButton.isUserInteractionEnabled = (rightIcon != nil)
        textFieldRightIcon = rightIcon

        if secureTextEntry != nil {
            textFieldView?.textField.isSecureTextEntry = secureTextEntry ?? false
        }
        if hasCountryCode == true {
            configureCountryCode(countryCode ?? phoneCountryCode)
        }
        updateTipText(with: tipText)
        if inputView != nil {
            textFieldView?.textField.inputView = inputView
        }
        if textContentType != nil {
            textFieldView?.textField.textContentType = textContentType
        }
        textFieldView?.setupCounterView(maxLength: counterMaxLength)
        if let counterMaxLength = counterMaxLength {
            maxLength = counterMaxLength
        }
    }

    /**
    Configure textfield style

    - Parameter textColor: Textfield text color
    - Parameter textFont: Textfield text font
    */
    public func configureTextFieldStyle(
        textColor: UIColor? = .VFGDefaultInputText,
        textFont: UIFont? = .vodafoneRegular(18)
    ) {
        textFieldTextColor = textColor
        textFieldTextFont = textFont
    }
    /// Text field configuration in case country code will be entered
    /// - Parameters:
    ///    - countryCode: Country code text value
    public func configureCountryCode(_ countryCode: String) {
        textFieldView?.countryCodeLabel.text = countryCode
        textFieldKeyboardType = .phonePad
        textFieldView?.countryCodeLabelWidthConstraint.constant = countryCodeLabelWidthDefault
        let textFieldCountryCodeWidthConstraint = textFieldView?.countryCodeLabelWidthConstraint.constant ?? 0
        textFieldView?.textFieldLeadingConstraints.constant = textFieldLeadingDefault +
            textFieldCountryCodeWidthConstraint + 6
    }

    /**
    Configure textfield toolbar

    - Parameter items: Textfield toolbar items
    - Parameter tintColor: Toolbar items color
    */
    public func configureInputAccessoryView(
        items: [UIBarButtonItem],
        tintColor: UIColor = .VFGPrimaryText
    ) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = tintColor
        toolBar.sizeToFit()
        toolBar.setItems(items, animated: false)
        toolBar.isUserInteractionEnabled = true
        textFieldView?.textField.inputAccessoryView = toolBar
    }
}
