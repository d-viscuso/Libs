//
//  BalanceHistoryViewController+CVMView.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 05/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension BalanceHistoryViewController {
    func showAutoTopUpCVMView() {
        cvmView = VFGCVM.loadXib(bundle: Bundle.foundation, nibName: "VFGCVM")
        setupLocalizationForCVMBanner()
        guard let cvmView = cvmView else { return }
        autoTopupCVMView.frame = cvmView.bounds
        bannerHeightConstraint.constant = bannerHeightConstraintConstant
        autoTopupCVMView.addSubview(cvmView)
    }

    func hideAutoTopUpCVMView() {
        bannerHeightConstraint.constant = 0
        cvmView?.removeFromSuperview()
    }

    func setupAcvtiveCVMBanner(autoTopUpType: String, exactOccurrence: String, autoTopUpAmount: Double) {
        cvmView?.removeFromSuperview()
        cvmView = VFGCVM.loadXib(bundle: Bundle.foundation, nibName: "VFGCVM")
        guard let historyViewModel = historyViewModel else { return }
        let viewModel = historyViewModel.setupLocalizationForActiveCVMBanner(
            autoTopUpType: autoTopUpType,
            exactOccurrence: exactOccurrence,
            autoTopUpAmount: autoTopUpAmount,
            delegate: self
        )
        cvmView?.configure(with: viewModel, isActive: true)
        guard let cvmView = cvmView else { return }
        autoTopupCVMView.frame = cvmView.bounds
        bannerHeightConstraint.constant = bannerHeightConstraintConstant
        autoTopupCVMView.addSubview(cvmView)
        isCVMActive = true
    }
}
