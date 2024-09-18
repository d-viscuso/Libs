//
//  VFGAutoBillLoadingViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie
/// Auto bill loading state quick action view model
class VFGAutoBillLoadingViewModel {
    /// An instance of *VFGAutoBillStateInternalProtocol*
    weak var delegate: VFGAutoBillStateInternalProtocol?
    /// Auto bill loading state quick action title
    var loadingTitle = ""
    /// Determine if auto bill is in editing mode or not
    var isEditingMode = false

    private func setLocalizedUIElementContent() {
        loadingTitle = isEditingMode ?
            "auto_bill_quick_action_edit_loading".localized(bundle: Bundle.mva10Framework) :
            "auto_bill_quick_action_loading".localized(bundle: Bundle.mva10Framework)
    }
    /// *VFGAutoBillLoadingViewModel* initializer
    /// - Parameters:
    ///    - delegate: Set the delegate for *VFGAutoBillLoadingViewModel*
    ///    - isEditingMode: Determine if auto bill is in editing mode or not
    init (
        delegate: VFGAutoBillStateInternalProtocol?,
        isEditingMode: Bool
    ) {
        self.delegate = delegate
        self.isEditingMode = isEditingMode
        setLocalizedUIElementContent()
        DispatchQueue.main.async {
            self.delegate?.loadingAutoBillPresent()
        }
    }
}

extension VFGAutoBillLoadingViewModel: VFQuickActionsModel {
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
        guard
            let loadingLogoView: VFGLoadingLogoView =
                VFGLoadingLogoView.loadXib(bundle: .foundation) else {
            return UIView()
        }

        loadingLogoView.configure(
            height: Constants.AutoBill.autoBillLoadingViewHeight,
            animationViewHeight: Constants.AutoBill.autoBillLoadingAnimationViewHeight,
            title: loadingTitle,
            titleFont: UIFont.vodafoneRegular(17),
            titleTextColor: UIColor.VFGRedWhiteText)

        loadingLogoView.startLoading()
        return loadingLogoView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }
}
