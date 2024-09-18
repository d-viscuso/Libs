//
//  VFGSuccessAutoBillViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Auto bill success state quick action view model
class VFGSuccessAutoBillViewModel {
    /// An instance of *VFGAutoBillStateInternalProtocol*
    weak var delegate: VFGAutoBillStateInternalProtocol?
    /// An instance of *VFQuickActionsProtocol*
    weak var quickActionDelegate: VFQuickActionsProtocol?
    /// Auto bill quick action successful month
    var month: String?
    /// Auto bill quick action successful selected day
    var selectedDay: Int?
    /// Auto bill quick action successful title
    var title = ""
    /// Auto bill quick action successful description
    var subtitle = ""
    /// Auto bill quick action successful primary button text
    var buttonTitle = ""
    /// Determine if auto bill is in editing mode or not
    var isEditingMode = false
    /// *VFGSuccessAutoBillViewModel* initializer
    /// - Parameters:
    ///    - delegate: Set the delegate for *VFGSuccessAutoBillViewModel*
    ///    - month: Current month for auto bill
    ///    - selectedDay: Selected day for auto bill
    ///    - isEditingMode: Determine if auto bill is in editing mode or not
    init(
        delegate: VFGAutoBillStateInternalProtocol?,
        month: String,
        selectedDay: Int?,
        isEditingMode: Bool
    ) {
        self.month = month
        self.selectedDay = selectedDay
        self.delegate = delegate
        self.isEditingMode = isEditingMode
        setLocalizedUIElementContent()
        DispatchQueue.main.async {
            self.delegate?.successAutoBillPresent()
        }
    }
    private func setLocalizedUIElementContent() {
        setContentWithCloseAndSuccessful()
    }
    /// Localization setup
    func setContentWithCloseAndSuccessful() {
        title = "auto_bill_quick_action_successful_title".localized(bundle: Bundle.mva10Framework)
        buttonTitle = "auto_bill_quick_action_successful_primary_button_text".localized(bundle: Bundle.mva10Framework)
        subtitle = String(
            format: "auto_bill_quick_action_successful_description".localized(bundle: Bundle.mva10Framework),
            arguments: [
                VFGDateHelper.daySuffix(day: selectedDay ?? 0),
                month ?? ""
            ])
    }
}

extension VFGSuccessAutoBillViewModel: VFQuickActionsModel {
    var isCloseButtonHidden: Bool {
        true
    }
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
        guard let autoBillSuccessView: VFGSuccessAutoBillView =
            VFGSuccessAutoBillView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        autoBillSuccessView.delegate = delegate
        autoBillSuccessView.configure(with: self)
        return autoBillSuccessView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
