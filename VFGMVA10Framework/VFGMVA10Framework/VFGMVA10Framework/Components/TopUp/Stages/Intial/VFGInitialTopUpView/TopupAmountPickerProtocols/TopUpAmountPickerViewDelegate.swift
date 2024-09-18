//
//  TopUpAmountPickerViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Burak Çokyıldırım on 15.09.2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

protocol TopUpAmountPickerViewDelegate: AnyObject {
    /// TopUp model.
    var model: VFGTopupActionModelProtocol? { get }

    var iconImageName: String { get }

    /// Method called when the user changes the selected topUp amount.
    /// - Parameters:
    ///    - selectedAmount: New selected amount.
    func didChangedPickerValue(
        selectedAmount: Double
    )
}
