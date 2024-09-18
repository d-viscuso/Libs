//
//  VFGPersonalAdvisorPreviousRequestStatus.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 17/08/2022.
//

import VFGMVA10Foundation

extension VFGPersonalAdvisorViewController: VFGPersonalAdvisorPreviousRequestResultProtocol {
    /// create quick action view of previous sent request by VFGStatusPreviousRequest ( sent, compeled, failed)
    public func createPreviousRequestStatusView(type: VFGStatusPreviousRequest) -> VFGPersonalAdvisorStatusRequestViewModel? {
        switch type {
        case .sent:
            self.status = .previousStatus(type: .sent)
            return VFGPersonalAdvisorStatusRequestViewModel(
                resultType: .customImage(.VFGClockRed),
                title: "personal_advisor_previous_status_title".localized(bundle: .mva10Framework),
                description: "personal_advisor_previous_status_sent_desc".localized(bundle: .mva10Framework),
                titleText: "personal_advisor_previous_status_sent_title".localized(bundle: .mva10Framework),
                primaryButton:
                    "personal_advisor_previous_status_sent_primary_title".localized(bundle: .mva10Framework)
            )
        case .completed:
            self.status = .previousStatus(type: .completed)
            return VFGPersonalAdvisorStatusRequestViewModel(
                resultType: .success,
                title: "personal_advisor_previous_status_title".localized(bundle: .mva10Framework),
                description: "personal_advisor_previous_status_completed_desc".localized(bundle: .mva10Framework),
                titleText: "personal_advisor_previous_status_completed_title".localized(bundle: .mva10Framework),
                primaryButton:
                    "personal_advisor_previous_status_completed_primary_title".localized(bundle: .mva10Framework)
            )
        case .failed:
            self.status = .previousStatus(type: .failed)
            return VFGPersonalAdvisorStatusRequestViewModel(
                resultType: .failure,
                title: "personal_advisor_previous_status_title".localized(bundle: .mva10Framework),
                description: "personal_advisor_previous_status_failed_desc".localized(bundle: .mva10Framework),
                titleText:
                    "personal_advisor_previous_status_sent_failed_title".localized(bundle: .mva10Framework),
                primaryButton:
                    "personal_advisor_previous_status_failed_primary_title".localized(bundle: .mva10Framework),
                secondaryButton:
                    "personal_advisor_previous_status_failed_secondary_title".localized(bundle: .mva10Framework)
            )
        }
    }
    func presentPreviousRequestStatusSuccessView(statusRequestmodel: VFGPersonalAdvisorStatusRequestViewModel?) {
        guard let statusRequestmodel = statusRequestmodel else {
            return
        }
        let model = VFGQuickActionsResultModel(
            type: statusRequestmodel.resultType,
            delegate: self,
            titleText: statusRequestmodel.titleText,
            descriptionText: statusRequestmodel.description,
            primaryButtonTitle: statusRequestmodel.primaryButton,
            titleFont: .vodafoneBold(28),
            descriptionFont: .vodafoneRegular(18))
        quickActionsResultView = VFGQuickActionsResultView(
            title: statusRequestmodel.title,
            isCloseButtonHidden: true,
            model: model
        )
        guard let quickActionsPreviousRequestStatusView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsPreviousRequestStatusView)
    }
    func presentPreviousRequestStatusFailureView(statusRequestmodel: VFGPersonalAdvisorStatusRequestViewModel?) {
        guard let statusRequestmodel = statusRequestmodel else {
            return
        }
        let model = VFGQuickActionsResultModel(
            type: statusRequestmodel.resultType,
            delegate: self,
            titleText: statusRequestmodel.titleText,
            descriptionText: statusRequestmodel.description,
            primaryButtonTitle: statusRequestmodel.primaryButton,
            secondaryButtonTitle: statusRequestmodel.secondaryButton,
            titleFont: .vodafoneBold(28),
            descriptionFont: .vodafoneRegular(18))
        quickActionsResultView = VFGQuickActionsResultView(
            title: statusRequestmodel.title,
            isCloseButtonHidden: true,
            model: model
        )
        guard let quickActionsPreviousRequestStatusView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsPreviousRequestStatusView)
    }
}
