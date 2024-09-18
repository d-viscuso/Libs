//
//  PaymentCardCell.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class PaymentCardCell: UITableViewCell {
    @IBOutlet weak var cardNameLabel: VFGLabel!
    @IBOutlet weak var expiryText: VFGLabel!
    @IBOutlet weak var expiryDateLabel: VFGLabel!
    @IBOutlet weak var nameOnCardLabel: VFGLabel!
    @IBOutlet weak var cardNumberLabel: VFGLabel!
    @IBOutlet weak var backgroundImage: VFGImageView!
    @IBOutlet weak var setPreferredButton: VFGButton!
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardImageHeight: NSLayoutConstraint!

    let setPreferredButtonHeight: CGFloat = 32
    let preferredCardImageViewExtraHeight: CGFloat = 20

    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalizedUIElementContent()
        cardContainerView.configureShadow()
    }

    func setLocalizedUIElementContent() {
        setPreferredButton.setTitle(
            "payment_make_payment_method_preferred".localized(bundle: .mva10Framework),
            for: .normal)
    }

    func configure(card: PaymentModelProtocol, cardBackgroundImage: UIImage?, cardTextColor: UIColor?) {
        backgroundImage.image = cardBackgroundImage ?? UIImage()
        setTextsColor(with: cardTextColor ?? UIColor())
        cardNameLabel.text = card.cardName

        if let expiry = card.expiry, !expiry.isEmpty {
            expiryDateLabel.text = expiry
            expiryText.text = "payment_expiry_date".localized(bundle: .mva10Framework).uppercased()
        }
        nameOnCardLabel.text = card.nameOnCard
        cardNumberLabel.text = card.securedDigits
        if let isPreferred = card.isPreferred {
            setPreferredButton.isHidden = isPreferred ? true : false
            separatorView.isHidden = isPreferred ? false : true
            buttonViewHeight.constant = isPreferred ? 0 : setPreferredButtonHeight
            cardImageHeight.constant = isPreferred ? preferredCardImageViewExtraHeight : 0
        }
        setVoiceOverAccessibility()
    }

    func setTextsColor(with color: UIColor) {
        expiryText.textColor = color
        expiryDateLabel.textColor = color
        nameOnCardLabel.textColor = color
        cardNumberLabel.textColor = color
    }
}

extension PaymentCardCell {
    private func setVoiceOverAccessibility() {
        cardNameLabel.accessibilityLabel = cardNameLabel.text ?? ""
        expiryText.accessibilityLabel = expiryText.text
        expiryDateLabel.accessibilityLabel = expiryDateLabel.text
        nameOnCardLabel.accessibilityLabel = nameOnCardLabel.text
        cardNumberLabel.accessibilityLabel = cardNumberLabel.text
        setPreferredButton.accessibilityLabel = setPreferredButton.titleLabel?.text
    }
}
