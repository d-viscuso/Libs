//
//  VFMVA10SwitchAccountTheme+switchAccount.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 07/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

extension VFMVA10SwitchAccountTheme {
    func setupViews() {
        switchAccountController?.addAccountButton.setTitle(
            "switch_account_quick_action_add_an_account_button_title".localized(bundle: .mva10Framework),
            for: .normal
        )
        let isHidden = switchAccountController?.delegate?.addAccountActionHandler == nil
        switchAccountController?.addAccountButton.isHidden = isHidden
        let cancelButtonTitle = "switch_account_quick_action_cancel_button_title".localized(bundle: .mva10Framework)
        switchAccountController?.cancelButton.setTitle(
            cancelButtonTitle,
            for: .normal
        )
        let isCancelButtonHidden = switchAccountController?.delegate?.addAccountActionHandler != nil
        switchAccountController?.cancelButton.isHidden = isCancelButtonHidden
        switchAccountController?.tableViewHeightConstraint.constant = contentViewHeight
    }
}
