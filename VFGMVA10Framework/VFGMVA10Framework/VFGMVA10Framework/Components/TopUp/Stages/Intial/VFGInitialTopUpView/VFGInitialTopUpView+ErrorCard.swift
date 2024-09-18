//
//  VFGInitialTopUpView+ErrorCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 15/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGInitialTopUpView {
    func showErrorCard() {
        let errorDescription = Constants.ErrorCard.description
        let errorConfig = VFGErrorModel(
            title: "",
            description: errorDescription,
            tryAgainText: Constants.ErrorCard.tryAgainText
        )

        errorCardView = VFGErrorView(
            error: errorConfig,
            accessibilityIdInitial: "TPerror"
        )

        guard let errorCardView = errorCardView else { return }

        errorCardView.refreshingClosure = { [weak self] in
            guard let self = self else { return }
            self.currentState = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.delegate?.tryAgain()
            }
        }
        addSubview(errorCardView)
        setupConstrains(errorCardView)
        errorCardView.alpha = 1
        giftImageView.isHidden = true
        changeViewsVisibility(isHidden: true)
    }

    private func changeViewsVisibility(isHidden: Bool = false) {
        subTitle.isHidden = isHidden
        paymentMethodsCard.isHidden = isHidden
        topupNowButton.isHidden = isHidden
        pickerContainerView.isHidden = isHidden
        separatorView.isHidden = isHidden
    }

    private func setupConstrains(_ errorCardView: VFGErrorView) {
        errorCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorCardView.topAnchor.constraint(
                equalTo: self.titleStackView.bottomAnchor,
                constant: errorCardConstraintConstant),
            errorCardView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            errorCardView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }

    func removeErrorCard() {
        errorCardView?.removeFromSuperview()
        errorCardView = nil
        changeViewsVisibility()
    }
}
