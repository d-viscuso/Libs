//
//  SubTrayCustomizationManager+Loading.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 26/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension SubTrayCustomizationManager {
    /// Loading screen presentation
    func presentLoadingView() {
        navigationController.isBackButtonHidden = true
        navigationController.isCloseButtonHidden = true
        navigationController.setTitle(
            title: "sub_tray_verification_confirmation_title".localized(bundle: .mva10Framework),
            for: UIViewController())
        topView = navigationController.viewControllers.last?.view
        topView?.startLoadingAnimation(
            style: .red,
            backgroundColor: .VFGWhiteBackground,
            title: "sub_tray_verification_loading_text".localized(bundle: .mva10Framework),
            titleFont: .vodafoneRegular(16.6),
            titleTextColor: .VFGRedText)
        isLoadingPresented = true
    }
    /// Loading screen dismiss
    func hideLoading() {
        topView?.endLoadingAnimation()
        isLoadingPresented = false
    }
}
