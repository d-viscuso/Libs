//
//  VFGTextField+UIPickerViewProtocols.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 1/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - UIPickerViewDataSource
extension VFGTextField: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        optionsList.count
    }
}

// MARK: - UIPickerViewDelegate
extension VFGTextField: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        optionsList[row]
    }
}
