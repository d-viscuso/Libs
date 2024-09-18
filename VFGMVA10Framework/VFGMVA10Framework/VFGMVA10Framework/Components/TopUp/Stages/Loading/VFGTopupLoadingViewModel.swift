//
//  VFGTopupLoadingViewModel.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Mahmoud Zaki on 1/15/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGTopupLoadingViewModel {
    weak var topUpDelegate: VFGTopUpProtocol?
    weak var delegate: VFGTopUpStateInternalProtocol?
    var subTitle = ""
    var paymentMethodTitle = ""
    var buttonTitle = ""
    var someOneElseIdentifier = ""
    var topUpStatus: TopUpStatus = .topUpMine
    var didPurchaseGift = false
    var topUpEntryPoint: TopUpEntryPoint = .discoveryCard

    private func setLocalizedUIElementContent() {
        subTitle = "top_up_quick_action_subtitle".localized(bundle: Bundle.mva10Framework)
        paymentMethodTitle = "top_up_quick_action_payment_method_title".localized(bundle: Bundle.mva10Framework)
        buttonTitle = "top_up_quick_action_close_button_text".localized(bundle: Bundle.mva10Framework)
    }

    init (
        topUpDelegate: VFGTopUpProtocol?,
        delegate: VFGTopUpStateInternalProtocol?,
        someOneElseIdentifier: String = "",
        topUpStatus: TopUpStatus = .topUpMine,
        didPurchaseGift: Bool,
        topUpEntryPoint: TopUpEntryPoint = .discoveryCard
    ) {
        self.topUpDelegate = topUpDelegate
        self.delegate = delegate
        self.didPurchaseGift = didPurchaseGift
        self.someOneElseIdentifier = someOneElseIdentifier
        self.topUpStatus = topUpStatus
        self.topUpEntryPoint = topUpEntryPoint
        self.setLocalizedUIElementContent()
        DispatchQueue.main.async {
            self.delegate?.loadingTopUpPresent()
        }
    }
}

extension VFGTopupLoadingViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        if topUpStatus == .topUpSomeOneElse {
            return String(
                format: "top_up_someone_else_quick_action_title_with_formatting".localized(bundle: .mva10Framework),
                arguments: [someOneElseIdentifier]
            )
        } else {
            return "top_up_quick_action_main_title".localized(bundle: Bundle.mva10Framework)
        }
    }

    var quickActionsContentView: UIView {
        guard let loadingScreenView: VFGTopupLoadingView =
            VFGTopupLoadingView.loadXib(bundle: Bundle.mva10Framework), topUpDelegate != nil
        else {
            return UIView()
        }
        loadingScreenView.delegate = delegate
        loadingScreenView.configure(didPurchaseGift: didPurchaseGift)
        return loadingScreenView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }

    var isCloseButtonHidden: Bool {
        topUpEntryPoint == .basicTopUpTile
    }
}
