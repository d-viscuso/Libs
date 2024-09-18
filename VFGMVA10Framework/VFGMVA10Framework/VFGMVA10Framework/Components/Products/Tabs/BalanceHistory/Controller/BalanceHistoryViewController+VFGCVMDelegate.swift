//
//  BalanceHistoryViewController+VFGCVMDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 31/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension BalanceHistoryViewController: VFGCVMProtocol {
    public func closeButtonDidPress() {
        hideAutoTopUpCVMView()
    }

    public func setupButtonDidPress() {
        guard let autoTopUpModel = historyViewModel?.autoTopUpModel else { return }
        VFGPaymentManager.setupAutoTopUpJourney(autoTopUpDelegate: autoTopUpModel)
        let autoTopUpManager = VFGPaymentManager.autoTopUpStateManager
        autoTopUpManager?.CVMDelegate = self
        autoTopUpManager?.initialAutoTopUpPresent()
    }

    public func editButtonDidPress() {
        guard let autoTopUpModel = historyViewModel?.autoTopUpModel else { return }
        VFGPaymentManager.setupAutoTopUpJourney(
            autoTopUpDelegate: autoTopUpModel,
            isEditingMode: true,
            activeAutoTopUpModel: activeAutoTopUpModel
        )
        let autoTopUpManager = VFGPaymentManager.autoTopUpStateManager
        autoTopUpManager?.CVMDelegate = self
        autoTopUpManager?.initialAutoTopUpPresent()
    }
}

extension BalanceHistoryViewController: VFGAutoTopUpStateManagerDelegate {
    func journeyDidFinish(activeAutoTopUpModel: VFGActiveAutoTopUpProtocol) {
        self.activeAutoTopUpModel = activeAutoTopUpModel
        setupAcvtiveCVMBanner(
            autoTopUpType: activeAutoTopUpModel.autoTopUpType,
            exactOccurrence: activeAutoTopUpModel.exactOccurrence,
            autoTopUpAmount: activeAutoTopUpModel.autoTopUpAmount
        )
    }
}
