//
//  SubTrayCustomizationManager+QuickActions.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 26/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension SubTrayCustomizationManager {
    /// *confirmationQuickActionModel* presentation
    func presentQuickAction() {
        let confirmationText = dataSource?.defaultNumberConfirmationText ??
            String(
                format: "sub_tray_verification_default_number_confirmation".localized(bundle: .mva10Framework),
                currentDefaultItem?.phoneNumber ?? "",
                subTrayItem.phoneNumber ?? "")
        confirmationQuickActionModel = SubTrayCustomizationQuickActionsModel(
            confirmationText: confirmationText,
            confirmationViewDelegate: self)
        guard let confirmationQuickActionModel = confirmationQuickActionModel else { return }
        VFQuickActionsViewController.presentQuickActionsViewController(
            with: confirmationQuickActionModel)
    }
}

// MARK: - VFGTwoActionsViewProtocol
extension SubTrayCustomizationManager: VFGTwoActionsViewProtocol {
    public func primaryButtonAction() {
        confirmationQuickActionModel?.delegate?.closeQuickAction(completion: nil)
        finish(state: .quickActionsConfirmation)
    }

    public func secondaryButtonAction() {
        confirmationQuickActionModel?.delegate?.closeQuickAction(completion: nil)
    }
}

// MARK: - VFGResultViewProtocol
extension SubTrayCustomizationManager: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        dismiss()
    }
}
