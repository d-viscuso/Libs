//
//  VFGPayBillViewModel.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGPayBillViewModel {
    weak var payBillDelegate: VFGPayBillProtocol?
    weak var delegate: VFGPayBillStateInternalProtocol?
    var subTitle = ""
    var paymentMethodTitle = ""
    var amount = ""
    var buttonTitle = ""
    var cancelTitle = ""
    var editLabel = ""
    var currency = ""

    init (
        payBillDelegate: VFGPayBillProtocol?,
        delegate: VFGPayBillStateInternalProtocol?
    ) {
        self.payBillDelegate = payBillDelegate
        self.delegate = delegate
        setLocalizedUIElementContent()
    }
    func presentPayBill() {
        DispatchQueue.main.async {
            self.delegate?.initialPayBillPresent()
        }
    }

    private func setLocalizedUIElementContent() {
        amount = String(payBillDelegate?.model?.amount ?? 0)
        paymentMethodTitle = "pay_bill_quick_action_payment_method_title".localized(bundle: Bundle.mva10Framework)
        currency = String(payBillDelegate?.model?.currency ?? "")
        buttonTitle = "pay_bill_quick_action_confirm_button_text".localized(bundle: Bundle.mva10Framework)
        editLabel = "pay_bill_quick_action_edit".localized(bundle: Bundle.mva10Framework)
        cancelTitle = "pay_bill_quick_action_close_button_text".localized(bundle: Bundle.mva10Framework)
        subTitle = "pay_bill_quick_action_subtitle".localized(bundle: Bundle.mva10Framework)
    }
}

extension VFGPayBillViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        String(
            format: "pay_bill_quick_action_main_title".localized(bundle: Bundle.mva10Framework),
            arguments: [
                String(payBillDelegate?.model?.billMonth ?? "")
            ])
    }

    var quickActionsContentView: UIView {
        guard let payBillActionView: VFGPayBillView =
            VFGPayBillView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        payBillActionView.configure(viewModel: self)
        payBillActionView.delegate = delegate
        return payBillActionView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
