//
//  VFGBarringViewController+AskChangesResultProtocol.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 20/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGBarringViewController: VFGBarringAskChangesResultProtocol {
    public func showSuccessQuickResult() {
        barringAskChangesStatus = true
        presentQuickActionsSuccessView()
    }

    public func showErrorQuickResult(model: VFGBarringItemViewModel) {
        barringAskChangesStatus = false
        currentBarringItemModel = model
        presentQuickActionsFailureView()
    }

    func presentQuickActionsSuccessView() {
        let model = VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: "barring_ask_changes_success_title".localized(bundle: .mva10Framework),
            descriptionText: "barring_ask_changes_success_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle: "barring_ask_changes_success_button_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(28),
            descriptionFont: .vodafoneRegular(18))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "barring_ask_changes_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: true,
            model: model
        )
        guard let quickActionsResultView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsResultView)
    }
    func presentQuickActionsFailureView() {
        let model = VFGQuickActionsResultModel(
            type: .failure,
            delegate: self,
            titleText: "barring_ask_changes_failure_title".localized(bundle: .mva10Framework),
            descriptionText: "barring_ask_changes_failure_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle: "barring_ask_changes_failure_button_title".localized(bundle: .mva10Framework),
            secondaryButtonTitle: "barring_ask_changes_cancel_button_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(28),
            descriptionFont: .vodafoneRegular(18))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "barring_ask_changes_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: true,
            model: model
        )
        guard let quickActionsResultView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsResultView)
    }
}
