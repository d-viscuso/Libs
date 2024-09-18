//
//  VFGAddNewCardViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 9/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class AddPaymentCardViewModel {
    weak var topUpDelegate: VFGTopUpProtocol?
    weak var delegate: VFGQuickActionStateInternalProtocol?
    var didPurchaseGift: Bool
    var creditCardValidator: CreditCardValidatorProtocol?
    var addPaymentCardCustomView: AddPaymentCardCustomView?

    init(
        topUpDelegate: VFGTopUpProtocol?,
        delegate: VFGQuickActionStateInternalProtocol?,
        didPurchaseGift: Bool,
        creditCardValidator: CreditCardValidatorProtocol? = nil,
        addPaymentCardCustomView: AddPaymentCardCustomView? = nil
    ) {
        self.topUpDelegate = topUpDelegate
        self.delegate = delegate
        self.didPurchaseGift = didPurchaseGift
        self.creditCardValidator = CreditCardValidator()
        self.addPaymentCardCustomView = addPaymentCardCustomView
    }
}

extension AddPaymentCardViewModel: VFQuickActionsModel {
    var quickActionsTitle: String {
        "quick_action_add_new_payment_card_title".localized(bundle: .mva10Framework)
    }

    var quickActionsContentView: UIView {
        if addPaymentCardCustomView != nil {
            addPaymentCardCustomView?.delegate = delegate
            return addPaymentCardCustomView ?? UIView()
        }
        guard let addNewCardView: AddPaymentCardView =
            AddPaymentCardView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return UIView()
        }
        addNewCardView.delegate = delegate
        addNewCardView.topUpDelegate = topUpDelegate
        let creditCardValidator = CreditCardValidator()
        AddPaymentDetailsView.creditCardValidator = creditCardValidator
        addNewCardView.configure(didPurchaseGift: didPurchaseGift)
        return addNewCardView
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) { }

    func closeQuickAction() {
        delegate?.dismiss()
    }

    var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }

    var isBackButtonHidden: Bool {
        false
    }

    func backQuickAction() {
        delegate?.backQuickAction()
    }
}
