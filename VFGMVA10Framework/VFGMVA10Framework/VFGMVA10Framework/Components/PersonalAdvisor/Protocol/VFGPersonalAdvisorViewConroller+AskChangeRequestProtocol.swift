//
//  VFGPersonalAdvisorViewConroller+AskChangeRequestProtocol.swift.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 12/08/2022.
//

import Foundation
import VFGMVA10Foundation

extension VFGPersonalAdvisorViewController: VFGPersonalAdvisorResultProtocol {
    public func showSuccessQuickResult() {
        presentQuickActionsSuccessView()
    }

    public func showErrorQuickResult() {
        presentQuickActionsFailureView()
    }

    func presentQuickActionsSuccessView() {
        let model = VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: "personal_advisor_sent_request_success_title".localized(bundle: .mva10Framework),
            descriptionText: "personal_advisor_sent_request_success_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle:
                "personal_advisor_sent_request_success_button_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(28),
            descriptionFont: .vodafoneRegular(18))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "personal_advisor_sent_request_title".localized(bundle: .mva10Framework),
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
            titleText: "personal_advisor_sent_request_failure_title".localized(bundle: .mva10Framework),
            descriptionText: "personal_advisor_sent_request_failure_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle:
                "personal_advisor_sent_request_failure_button_title".localized(bundle: .mva10Framework),
            secondaryButtonTitle: "personal_advisor_sent_request_cancel_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(28),
            descriptionFont: .vodafoneRegular(18))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "personal_advisor_sent_request_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: true,
            model: model
        )
        guard let quickActionsResultView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsResultView)
    }
}
