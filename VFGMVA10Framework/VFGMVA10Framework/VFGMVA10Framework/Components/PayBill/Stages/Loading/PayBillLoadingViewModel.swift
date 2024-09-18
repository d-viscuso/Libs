//
//  PayBillLoadingViewModel.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class PayBillLoadingViewModel {
    weak var delegate: VFGPayBillStateInternalProtocol?
    var loadingTitle = ""
    var month = ""

    private func setLocalizedUIElementContent() {
        loadingTitle = "pay_bill_quick_action_loading_main".localized(bundle: Bundle.mva10Framework)
    }

    init (
        delegate: VFGPayBillStateInternalProtocol?,
        month: String
    ) {
        self.month = month
        self.delegate = delegate
        setLocalizedUIElementContent()
        DispatchQueue.main.async {
            self.delegate?.loadingPayBillPresent()
        }
    }
}

extension PayBillLoadingViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        String(
            format: "pay_bill_quick_action_main_title".localized(bundle: Bundle.mva10Framework),
            arguments: [
                String(month)
            ])
    }

    var quickActionsContentView: UIView {
        guard let loadingScreenView: PayBillLoadingView =
            PayBillLoadingView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        loadingScreenView.delegate = delegate
        loadingScreenView.configure(viewModel: self)
        return loadingScreenView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }
}
