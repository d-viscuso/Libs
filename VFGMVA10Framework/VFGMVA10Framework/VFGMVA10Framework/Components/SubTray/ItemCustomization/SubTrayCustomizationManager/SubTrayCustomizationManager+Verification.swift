//
//  SubTrayCustomizationManager+Verification.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 26/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension SubTrayCustomizationManager {
    /// *SubTrayItemVerificationViewController* configuration
    func configureVerificationViewController() {
        verificationViewController = SubTrayItemVerificationViewController.instance()
            as SubTrayItemVerificationViewController
        let verificationText = dataSource?.verificationConfirmationText ??
            String(
                format: "sub_tray_verification_sms_confirmation_description".localized(bundle: .mva10Framework),
                subTrayItem.phoneNumber ?? "")
        verificationViewController?.configure(
            pinCodeLength: dataSource?.verificationCodeLength ?? 6,
            verificationText: verificationText,
            delegate: self,
            navigationDelegate: self)
    }
    /// Handle presenting *SubTrayItemVerificationViewController*
    func presentVerificationViewController() {
        configureVerificationViewController()
        guard let verificationViewController = verificationViewController else { return }
        navigationController.pushViewController(verificationViewController, animated: true)
        navigationController.setTitle(
            title: "sub_tray_verification_confirmation_title".localized(bundle: .mva10Framework),
            for: verificationViewController)
    }
}
