//
//  VFGAutoBillFailureViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Auto bill failure state quick action view model
class VFGAutoBillFailureViewModel {
    /// An instance of *VFGAutoBillStateInternalProtocol*
    weak var delegate: VFGAutoBillStateInternalProtocol?
    /// Auto bill quick action failure title
    var sectionTitle = ""
    /// Auto bill quick action failure description
    var subTitle = ""
    /// Auto bill quick action failure try again
    var buttonTitle = ""
    /// Auto bill quick action failure cancel
    var cancelButtonTitle = ""
    /// *VFGAutoBillFailureViewModel* initializer
    /// - Parameters:
    ///    - delegate: Set the delegate for *VFGAutoBillFailureViewModel*
    init (delegate: VFGAutoBillStateInternalProtocol?) {
        self.delegate = delegate
        setupContentLabels()
        DispatchQueue.main.async {
            self.delegate?.presentFailureView()
        }
    }
    /// Localization setup
    func setupContentLabels() {
        sectionTitle = "auto_bill_quick_action_failure_title".localized(bundle: Bundle.mva10Framework)
        subTitle = "auto_bill_quick_action_failure_description".localized(bundle: Bundle.mva10Framework)
        buttonTitle = "auto_bill_quick_action_failure_try_again".localized(bundle: Bundle.mva10Framework)
        cancelButtonTitle = "auto_bill_quick_action_failure_cancel".localized(bundle: Bundle.mva10Framework)
    }
}

extension VFGAutoBillFailureViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        "auto_bill_quick_action_title".localized(bundle: Bundle.mva10Framework)
    }

    var quickActionsContentView: UIView {
        guard let autoBillFailureView: VFGAutoBillFailureView =
            VFGAutoBillFailureView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        autoBillFailureView.delegate = delegate
        autoBillFailureView.configure(with: self)
        return autoBillFailureView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
