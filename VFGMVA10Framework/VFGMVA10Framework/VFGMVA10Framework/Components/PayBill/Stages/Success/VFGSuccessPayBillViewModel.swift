//
//  VFGSuccessPayBillViewModel.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGSuccessPayBillViewModel {
    weak var delegate: VFGPayBillStateInternalProtocol?
    weak var quickActionDelegate: VFQuickActionsProtocol?
    var month: String?

    var sectionTitle = ""
    var subTitle = ""
    var buttonTitle = ""

    init(
        delegate: VFGPayBillStateInternalProtocol?,
        month: String
    ) {
        self.month = month
        self.delegate = delegate
        setLocalizedUIElementContent()
        DispatchQueue.main.async {
            self.delegate?.successPayBillPresent()
        }
    }
    private func setLocalizedUIElementContent() {
        setContentWithCloseAndSuccessful()
    }

    func setContentWithCloseAndSuccessful() {
        subTitle = "pay_bill_quick_action_successful_description".localized(bundle: Bundle.mva10Framework)
        buttonTitle = "pay_bill_quick_action_successful_button_title".localized(bundle: Bundle.mva10Framework)
        sectionTitle = String(
            format: "pay_bill_quick_action_successful".localized(bundle: Bundle.mva10Framework),
            arguments: [
                String(month ?? "")
            ])
    }
}

extension VFGSuccessPayBillViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        String(
            format: "pay_bill_quick_action_main_title".localized(bundle: Bundle.mva10Framework),
            arguments: [
                String(month ?? "")
            ])
    }

    var quickActionsContentView: UIView {
        guard let payBillSuccessView: VFGSuccessPayBillView =
            VFGSuccessPayBillView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        payBillSuccessView.delegate = delegate
        payBillSuccessView.configure(with: self)
        return payBillSuccessView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
