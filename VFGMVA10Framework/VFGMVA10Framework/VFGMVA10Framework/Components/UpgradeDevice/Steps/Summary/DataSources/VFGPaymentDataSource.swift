//
//  VFGPaymentDataSource.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

class VFGPaymentDataSource: VFGSelectionViewDataSource {
    var paymentCards: [PaymentModelProtocol] = []
    var selectedIndex: Int = 0

    func fetchPaymentCards(_ completion: @escaping () -> Void) {
        VFGPaymentManager.fetchPaymentCards { [weak self] paymentCards, _ in
            guard let self = self, let paymentCards = paymentCards else {
                return
            }

            self.paymentCards = paymentCards
            completion()
        }
    }

    func headerTitle() -> String {
        "device_upgrade_summary_step_payment_method".localized(bundle: .mva10Framework)
    }

    func numberOfSelections() -> Int {
        paymentCards.count + 1
    }

    func titleForSelection(at index: Int) -> String {
        guard index != paymentCards.count else {
            // todo: localization
            return "Billing"
        }
        return paymentCards[index].brand?.rawValue ?? ""
    }

    func subtitleForSelection(at index: Int) -> String {
        guard index != paymentCards.count else {
            // todo: localization
            return "Add it to the bill"
        }

        guard let lastFourDigits = paymentCards[index].lastFourDigits else {
            return ""
        }
        let ending = "device_upgrade_summary_step_payment_card_ending".localized(bundle: .mva10Framework)
        return "\(ending) \(lastFourDigits)"
    }

    func selectedItemSubtitleText() -> String? {
        nil
    }
}
