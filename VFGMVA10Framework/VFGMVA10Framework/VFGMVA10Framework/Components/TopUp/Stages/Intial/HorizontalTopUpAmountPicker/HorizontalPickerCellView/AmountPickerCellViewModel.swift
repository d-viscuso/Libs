//
//  AmountPickerCellViewModel.swift
//  VFGMVA10Framework
//
//  Created by Burak Çokyıldırım on 9.09.2023.
//

import Foundation

struct AmountPickerCellViewModel {
    var currencyText: String
    var currencyPosition: CurrencyPositon
    var amountText: String
    var hasGift: Bool
    var giftIconImageName: String

    enum CurrencyPositon {
        case left
        case right
    }
}
