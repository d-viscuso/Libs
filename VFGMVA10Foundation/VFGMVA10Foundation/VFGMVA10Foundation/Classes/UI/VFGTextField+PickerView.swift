//
//  VFGTextField+PickerView.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 1/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import UIKit

extension VFGTextField {
    /// Text field configurations
    /// - Parameters:
    ///    - topTitleText: Text value of *topLabel* in *textFieldView*
    ///    - placeHolder: Place holder text of *textField* in *textFieldView*
    ///    - pickerViewDoneTitle: Text value for done button in input accessory view in *textField* of *textFieldView*
    ///    - pickerViewCancelTitle: Text value for cancel button in input accessory view in *textField* of *textFieldView*
    ///    - countries: Text field countries list
    public func configureCountries(
        topTitleText: String? = nil,
        placeHolder: String? = nil,
        pickerViewDoneTitle: String,
        pickerViewCancelTitle: String,
        countries: [String]? = nil
    ) {
        let options = countries ?? allCountries()
        configureOptionsList(
            topTitleText: topTitleText,
            placeHolder: placeHolder,
            pickerViewDoneTitle: pickerViewDoneTitle,
            pickerViewCancelTitle: pickerViewCancelTitle,
            options: options)
    }
    /// Text field configurations
    /// - Parameters:
    ///    - topTitleText: Text value of *topLabel* in *textFieldView*
    ///    - placeHolder: Place holder text of *textField* in *textFieldView*
    ///    - placeHolderColor: Place holder text color of *textField* in *textFieldView*
    ///    - pickerViewDoneTitle: Text value for done button in input accessory view in *textField* of *textFieldView*
    ///    - pickerViewCancelTitle: Text value for cancel button in input accessory view in *textField* of *textFieldView*
    ///    - options: Text field options list
    ///    - isBorderedTextField: Determine if *textFieldView* has borders or not
    ///    - rightIcon: Image of *rightButton* in *textFieldView*
    public func configureOptionsList(
        topTitleText: String? = nil,
        placeHolder: String? = nil,
        placeHolderColor: UIColor? = nil,
        pickerViewDoneTitle: String,
        pickerViewCancelTitle: String,
        options: [String],
        isBorderedTextField: Bool = true,
        rightIcon: UIImage? = VFGFoundationAsset.Image.icChevronDown
    ) {
        if let placeHolderColor = placeHolderColor {
            self.placeHolderColor = placeHolderColor
        }
        isOptionsPickerTextField = true
        textFieldTopTitleText = topTitleText
        textFieldPlaceHolderText = placeHolder
        self.optionsList = options

        textFieldView?.rightButton.isUserInteractionEnabled = false
        textFieldView?.textField.tintColor = .clear
        textFieldRightIcon = rightIcon

        if !isBorderedTextField {
            textFieldView?.changeBorderState(to: .none)
            textFieldView?.topInsetConstraint.constant = 0
            textFieldView?.bottomInsetConstraint.constant = 0
        }
        setupOptionsPickerTextField(
            pickerViewDoneTitle: pickerViewDoneTitle,
            pickerViewCancelTitle: pickerViewCancelTitle
        )
    }

    @objc func setupOptionsPickerTextField(
        pickerViewDoneTitle: String,
        pickerViewCancelTitle: String
        ) {
        pickerView = UIPickerView()
        toolBar = UIToolbar()
        guard let pickerView = pickerView,
            let toolBar = toolBar else { return }

        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .VFGWhiteBackground

        // ToolBar initialization
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .VFGPrimaryText
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: pickerViewDoneTitle,
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelButton = UIBarButtonItem(
            title: pickerViewCancelTitle,
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textFieldView?.textField.inputView = pickerView
        textFieldView?.textField.inputAccessoryView = toolBar
    }

    @objc func doneButtonTapped() {
        guard let selectedRow = pickerView?.selectedRow(inComponent: 0) else {
            cancelButtonTapped()
            return
        }
        textFieldView?.textField.resignFirstResponder()
        if !optionsList.isEmpty,
            0..<optionsList.count ~= selectedRow {
            textFieldText = optionsList[selectedRow]
        }
    }

    @objc func cancelButtonTapped() {
        textFieldView?.textField.resignFirstResponder()
    }

    func allCountries() -> [String] {
        Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }.sorted()
    }
}
