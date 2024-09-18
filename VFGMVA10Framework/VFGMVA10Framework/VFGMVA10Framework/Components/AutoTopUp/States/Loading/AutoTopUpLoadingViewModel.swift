//
//  AutoTopUpLoadingViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 09/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie
/// Auto top up loading quick action view model
class AutoTopUpLoadingViewModel {
    /// An instance of *VFGAutoTopUpStateInternalProtocol*
    weak var delegate: VFGAutoTopUpStateInternalProtocol?
    /// Auto top up quick action loading title
    var loadingTitle = ""
    /// Determine if auto bill is in editing mode or not
    var isEditingMode = false

    private func setLocalizedUIElementContent() {
        loadingTitle = isEditingMode ?
            "auto_top_up_quick_action_edit_loading".localized(bundle: Bundle.mva10Framework) :
            "auto_top_up_quick_action_loading".localized(bundle: Bundle.mva10Framework)
    }
    /// *AutoTopUpLoadingViewModel* initializer
    /// - Parameters:
    ///    - isEditingMode: Determine if auto bill is in editing mode or not
    init (isEditingMode: Bool = false) {
        self.isEditingMode = isEditingMode
        setLocalizedUIElementContent()
    }
}

extension AutoTopUpLoadingViewModel: VFQuickActionsModel {
    func closeQuickAction() {}

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        isEditingMode ?
            "auto_top_up_quick_action_edit_title".localized(bundle: Bundle.mva10Framework) :
            "auto_top_up_quick_action_title".localized(bundle: Bundle.mva10Framework)
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
