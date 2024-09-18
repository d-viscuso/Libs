//
//  VFGPaymentMethodCellViewModel.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 9/24/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
/// A model that contains card's image, name, number & expiry date
public struct VFGPaymentMethodCellViewModel {
    public var cardImage: UIImage?
    public var cardName: String?
    public var cardNumber: String?
    public var cardExpiryDate: String?
    public init(
        cardImage: UIImage?,
        cardName: String?,
        cardNumber: String?,
        cardExpiryDate: String?
    ) {
        self.cardImage = cardImage
        self.cardName = cardName
        self.cardNumber = cardNumber
        self.cardExpiryDate = cardExpiryDate
    }
}
