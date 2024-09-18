//
//  VFGInitialTopUpView+Animations.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 15/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGInitialTopUpView {
    func animateViewAppearance() {
        UIView.animate(withDuration: 0.3) {
            self.topupNowButton.alpha = 1
            self.titleStackView.alpha = 1
        }
    }

    func animateViewDismissal() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.topupNowButton.alpha = 0
                self.titleStackView.alpha = 0
            },
            completion: { _ in
                self.delegate?.confirmTopUp(
                    selectedAmount: self.selectedAmount,
                    paymentCard: self.paymentMethodsCard.shownPaymentCards.first)
            }
        )
    }
}
