//
//  VFGPaymentMethodLargeCell.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 9/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

/// VFGPaymentMethodLargeCell is a cell that represents the card's image, name, number & expiry date
public class VFGPaymentMethodLargeCell: UICollectionViewCell {
    @IBOutlet weak var cardImageView: VFGImageView!
    @IBOutlet weak var cardNameLabel: VFGLabel!
    @IBOutlet weak var cardNumberLabel: VFGLabel!
    @IBOutlet weak var cardExpiryDateLabel: VFGLabel!

    /// configure VFGPaymentMethodLargeCell
    /// - Parameter model: It is a model that contains the content of the card such as the card's image, name, number & expiry date
    public func configure(with model: VFGPaymentMethodCellViewModel?) {
        cardImageView.image = model?.cardImage
        cardNameLabel.text = model?.cardName
        cardNumberLabel.text = model?.cardNumber
        cardExpiryDateLabel.text = model?.cardExpiryDate
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        cardImageView.accessibilityLabel = "Card type"
        if let cardName = cardNameLabel.text {
            cardNameLabel.accessibilityLabel = "Your card name is \(cardName)"
        } else {
            cardNameLabel.accessibilityLabel = "No card name was found"
        }
        if let cardNumber = cardNumberLabel.text {
            let cardNumberIndex = cardNumber.index(cardNumber.endIndex, offsetBy: -4)
            let lastFourDigits = String(cardNumber[cardNumberIndex...])
            cardNumberLabel.accessibilityLabel = "Your card number ends with \(lastFourDigits)"
        } else {
            cardNumberLabel.accessibilityLabel = "No card numbers were found"
        }
        cardExpiryDateLabel.accessibilityLabel = cardExpiryDateLabel.text ?? "No expiry date was found"
    }
}
