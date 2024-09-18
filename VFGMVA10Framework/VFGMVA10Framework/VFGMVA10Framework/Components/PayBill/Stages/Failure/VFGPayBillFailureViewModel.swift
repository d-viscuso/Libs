//
//  VFGPayBillFailureViewModel.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 12/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGPayBillFailureViewModel {
    weak var delegate: VFGPayBillStateInternalProtocol?

    var sectionTitle = ""
    var subTitle = ""
    var buttonTitle = ""
    var cancelButtonTitle = ""
    var billMonth = ""

    init (
        delegate: VFGPayBillStateInternalProtocol?,
        billMonth: String
    ) {
        self.delegate = delegate
        self.billMonth = billMonth
        setupContentLabels()
        DispatchQueue.main.async {
            self.delegate?.presentFailureView()
        }
    }

    func setupContentLabels() {
        sectionTitle = "pay_bill_quick_action_failure_title".localized(bundle: Bundle.mva10Framework)
        subTitle = "pay_bill_quick_action_failure_description".localized(bundle: Bundle.mva10Framework)
        buttonTitle = "pay_bill_quick_action_failure_try_again".localized(bundle: Bundle.mva10Framework)
        cancelButtonTitle = "pay_bill_quick_action_failure_cancel".localized(bundle: Bundle.mva10Framework)
    }
}

extension VFGPayBillFailureViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        String(
            format: "pay_bill_quick_action_main_title".localized(bundle: Bundle.mva10Framework),
            arguments: [
                String(billMonth)
            ])
    }

    var quickActionsContentView: UIView {
        guard let payBillFailureView: VFGPayBillFailureView =
            VFGPayBillFailureView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        payBillFailureView.delegate = delegate
        payBillFailureView.configure(with: self)
        return payBillFailureView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
