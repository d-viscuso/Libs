//
//  PriceInfoQuickActionViewModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class PriceInfoQuickActionViewModel: VFQuickActionsModel {
    weak var quickActionDelegate: VFQuickActionsProtocol?
    weak var infoConfirmAlertDelegate: VFGInfoConfirmationAlertDelegate?

    init() {
        infoConfirmAlertDelegate = self
    }

    var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }

    var isCloseButtonHidden: Bool { true }

    var quickActionsTitle: String {
        return "device_upgrade_summary_step_total_cost_first_bill_why_modal_title"
            .localized(bundle: .mva10Framework)
    }

    var quickActionsContentView: UIView {
        guard let confirmationView: VFGInfoConfirmationAlert = UIView
            .loadXib(bundle: Bundle.foundation) else {
                return UIView()
        }

        confirmationView.delegate = infoConfirmAlertDelegate
        confirmationView.model = VFGInfoConfirmationAlertModel(
            infoQuestion:
                String(
                    format: "device_upgrade_summary_step_total_cost_first_bill_why_modal_question"
                        .localized(bundle: .mva10Framework),
                    "€195"
                ),
            infoAnswer: "device_upgrade_summary_step_total_cost_first_bill_why_modal_description"
                .localized(bundle: .mva10Framework),
            confirmButtonTitle: "device_upgrade_summary_step_total_cost_first_bill_why_modal_button_title"
                .localized(bundle: .mva10Framework))
        confirmationView.configureStyle(buttonStyleValue: 0)
        return confirmationView
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        quickActionDelegate = delegate
    }

    func closeQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }
}

extension PriceInfoQuickActionViewModel: VFGInfoConfirmationAlertDelegate {
    func confirmActionPressed(completion: (() -> Void)?) {
        closeQuickAction()
    }
}
