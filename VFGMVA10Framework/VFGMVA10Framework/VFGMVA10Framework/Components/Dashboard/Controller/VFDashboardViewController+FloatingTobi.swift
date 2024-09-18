//
//  VFDashboardViewController+banner.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 05/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
extension VFDashboardViewController: VFGFloatingTobiContainerProtocol {
    public var containerView: UIView? {
        view
    }
    public var boundaryView: UIView? {
        return collectionBackgroundView
    }
}

extension VFDashboardViewController {
    /// Show multiple accounts banner in case of current user has multiple accounts
    func showMultipleAccountsBanner() {
        let selectedAccount = VFGUser.shared.selectedAccount()
        let message = String(
            format: "multiple_account_banner_message".localized(bundle: Bundle.mva10Framework),
            arguments: [
                selectedAccount?.name ?? ""
            ])
        let imageName = selectedAccount?.imageName ?? "icAdmin"
        showTopBanner(message: message, imageName: imageName, duration: multipleAccountsBannerInterval)
        userDefaults.isMultipleAccountBannerShown = true
    }
}
