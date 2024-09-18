//
//  TopUpAmountPickerViewProtocol.swift
//  VFGMVA10Framework
//
//  Created by Burak Çokyıldırım on 15.09.2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

protocol TopUpAmountPickerViewProtocol: UIView {
    var selectedAmount: Double { get }

    func configure(
        with delegate: TopUpAmountPickerViewDelegate?,
        hasOffer: Bool,
        completion: (() -> Void)?
    )
    func selectRow(_ index: Int)
    func reload()
}
