//
//  VFGInitialTopUpView+TopUpAmountPickerViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Burak Çokyıldırım on 15.09.2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGInitialTopUpView: TopUpAmountPickerViewDelegate {
    var model: VFGTopupActionModelProtocol? {
        topUpDelegate?.model
    }

    func didChangedPickerValue(selectedAmount: Double) {
        topUpDelegate?.didChangedPickerValue(selectedAmount: selectedAmount, topupButton: topupNowButton)
    }
}
