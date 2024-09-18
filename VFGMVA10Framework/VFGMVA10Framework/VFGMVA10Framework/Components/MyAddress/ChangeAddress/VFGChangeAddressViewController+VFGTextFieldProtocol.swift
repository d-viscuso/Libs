//
//  VFGChangeAddressViewController+VFGTextFieldProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/3/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGChangeAddressViewController: VFGTextFieldProtocol {
    public func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) {}

    public func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) {
        validationTimer.invalidate()
        checkFrontendValidation(model: model)
    }

    public func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        validationTimer.invalidate()
        validationTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.validationDelay,
            repeats: false
        ) { [weak self] timer in
            guard let self = self else { return }
            timer.invalidate()
            self.checkFrontendValidation(model: self.model)
        }
    }

    public func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {}

    func checkFrontendValidation(model: VFGAddressModel) {
        delegate?.validate(model: model) { result in
            saveButton.isEnabled = result
        }
    }
}
