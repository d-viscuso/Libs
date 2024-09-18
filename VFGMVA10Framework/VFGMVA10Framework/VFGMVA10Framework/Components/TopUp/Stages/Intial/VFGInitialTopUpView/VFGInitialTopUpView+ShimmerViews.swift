//
//  VFGInitialTopUpView+ShimmerViews.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 15/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGInitialTopUpView {
    func showShimmer() {
        topUpShimmerView = TopUpShimmerView(
            withCustomAmount: withCustomAmount,
            amountPickerAxis: viewModel?.amountPickerAxis ?? .vertical,
            frame: bounds
        )
        topUpShimmerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        topUpShimmerView?.startShimmer()
        guard let topUpShimmerView = topUpShimmerView else {
            return
        }
        addSubview(topUpShimmerView)
    }

    func hideShimmer() {
        topUpShimmerView?.stopShimmer()
    }
}
