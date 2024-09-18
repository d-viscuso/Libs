//
//  VFGInitialTopUpView+VFGTopUpActionsProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 11/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension VFGInitialTopUpView: VFGTopUpActionsProtocol {
    func reloadTopUp() {
        viewModel?.reloadTopUp { [weak self] in
            self?.amountPickerView?.reload()
        }
    }

    func updateState(_ newState: InitialTopUpState) {
        currentState = newState
    }
}
