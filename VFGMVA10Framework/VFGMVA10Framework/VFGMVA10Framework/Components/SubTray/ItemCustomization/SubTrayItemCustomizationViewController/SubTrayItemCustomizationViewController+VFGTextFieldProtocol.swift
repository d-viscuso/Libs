//
//  SubTrayItemCustomizationViewController+VFGTextFieldProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 21/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension SubTrayItemCustomizationViewController: VFGTextFieldProtocol {
    public func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        itemTitleLabel.text = text
        updatePrimaryButtonState()
    }

    public func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) {}
    public func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) {}
    public func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {}
}
