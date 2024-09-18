//
//  VFGAutoBillViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Auto bill quick action view model
class VFGAutoBillViewModel {
    /// Auto bill quick action model
    var model: VFGAutoBillActionModelProtocol?
    /// An instance of *VFGAutoBillStateInternalProtocol*
    weak var delegate: VFGAutoBillStateInternalProtocol?
    /// Auto bill date filter title
    var title = ""
    /// Pay bill quick action payment method title
    var paymentMethodTitle = ""
    /// Auto bill date filter description
    var subtitle = ""
    /// Auto bill quick action primary button text
    var buttonTitle = ""
    /// Auto bill quick action secondary button text
    var cancelTitle = ""
    /// Pay bill quick action edit
    var editLabel = ""
    /// Determine if auto bill is in editing mode or not
    var isEditingMode = false
    /// *VFGAutoBillViewModel* initializer
    /// - Parameters:
    ///    - model: Auto bill quick action model data
    ///    - delegate: Set the delegate for *VFGAutoBillViewModel*
    ///    - isEditingMode: Determine if auto bill is in editing mode or not
    init (
        model: VFGAutoBillActionModelProtocol?,
        delegate: VFGAutoBillStateInternalProtocol?,
        isEditingMode: Bool
    ) {
        self.model = model
        self.delegate = delegate
        self.isEditingMode = isEditingMode
        setLocalizedUIElementContent()
    }
    /// Present auto bill quick action
    func presentAutoBill() {
        DispatchQueue.main.async {
            self.delegate?.initialAutoBillPresent()
        }
    }

    private func setLocalizedUIElementContent() {
        subtitle = "auto_bill_date_filter_description".localized(bundle: Bundle.mva10Framework)
        paymentMethodTitle = "pay_bill_quick_action_payment_method_title".localized(bundle: Bundle.mva10Framework)
        buttonTitle = "auto_bill_quick_action_primary_button_text".localized(bundle: Bundle.mva10Framework)
        editLabel = "pay_bill_quick_action_edit".localized(bundle: Bundle.mva10Framework)
        cancelTitle = "auto_bill_quick_action_secondary_button_text".localized(bundle: Bundle.mva10Framework)
        title = "auto_bill_date_filter_title".localized(bundle: Bundle.mva10Framework)
    }
}

extension VFGAutoBillViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        isEditingMode ?
            "auto_bill_quick_action_edit_title".localized(bundle: Bundle.mva10Framework) :
            "auto_bill_quick_action_title".localized(bundle: Bundle.mva10Framework)
    }

    var quickActionsContentView: UIView {
        guard let autoBillActionView: VFGAutoBillView =
            VFGAutoBillView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        autoBillActionView.delegate = delegate
        if let selectedDay = model?.selectedDay {
            autoBillActionView.selectedDay = selectedDay
        }
        autoBillActionView.configure(viewModel: self)
        return autoBillActionView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
