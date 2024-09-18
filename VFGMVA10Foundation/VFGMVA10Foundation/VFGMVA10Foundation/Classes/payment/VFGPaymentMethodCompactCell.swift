//
//  VFGPaymentMethodCompactCell.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 9/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

/// A delegate protocol that manages compact cell
public protocol VFGPaymentMethodCompactCellDelegate: AnyObject {
    /// delete a specific card
    /// - Parameters:
    ///   - cardId: The id of the card that will be deleted
    func deleteCard(with cardId: String?)
}

/// A cell that represents the payment method compact
public class VFGPaymentMethodCompactCell: UICollectionViewCell {
    @IBOutlet weak var cardImageView: VFGImageView!
    @IBOutlet weak var cardImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardNameLabel: VFGLabel!
    @IBOutlet weak var cardNumberLabel: VFGLabel!
    @IBOutlet weak var deleteButton: VFGButton!

    let cardNameFontSize: CGFloat = 18
    /// Check if the item is selected
    public var isItemSelected = false {
        didSet {
            isItemSelected ? setupSelectedUI() : setupDeselectedUI()
        }
    }
    var imageSmallSize: CGSize {
        CGSize(width: 40, height: 40)
    }
    var imageLargeSize: CGSize {
        CGSize(width: frame.width * 75, height: 26)
    }

    /// A callback delegate
    public weak var delegate: VFGPaymentMethodCompactCellDelegate?
    var cardId: String?
    public override func prepareForReuse() {
        super.prepareForReuse()

        updateImageConstraints(isFlexibleSize: false)
    }

    /// setup the UI if the item is selected
    public func setupSelectedUI() {
        layer.borderColor = UIColor.VFGSelectedCellBorder.cgColor
        cardNameLabel.font = UIFont.vodafoneBold(cardNameFontSize)
        layer.borderWidth = 2
    }

    /// setup the UI if the item is deselected
    public func setupDeselectedUI() {
        layer.borderColor = UIColor.VFGDefaultSelectionOutline.cgColor
        cardNameLabel.font = UIFont.vodafoneRegular(cardNameFontSize)
        layer.borderWidth = 1
    }

    /// configure VFGPaymentMethodCompactCell
    /// - Parameters:
    ///   - model: A model that contains the card's image, name, number & expirydate
    ///   - cardId: card Id
    ///   - showDeleteButton: To show a deleted button
    ///   - enableLargeImageSize: To enable large image size
    public func configure(
        with model: VFGPaymentMethodCellViewModel?,
        and cardId: String? = nil,
        showDeleteButton: Bool = false,
        enableLargeImageSize: Bool = false
    ) {
        cardImageView.image = model?.cardImage
        cardNameLabel.text = model?.cardName
        cardNumberLabel.text = model?.cardNumber
        self.cardId = cardId
        deleteButton.isHidden = !showDeleteButton
        updateImageConstraints(isFlexibleSize: enableLargeImageSize)
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        cardImageView.accessibilityLabel = "Card type"
        if let cardName = cardNameLabel.text {
            cardNameLabel.accessibilityLabel = "This card name is \(cardName)"
        } else {
            cardNameLabel.accessibilityLabel = "No card was found"
        }
        if let cardNumberText = cardNumberLabel.text {
            let text = cardNumberText.replacingOccurrences(of: "*", with: "")
            cardNumberLabel.accessibilityLabel = text
        } else {
            cardNumberLabel.accessibilityLabel = "No card numbers were found"
        }
    }

    @IBAction func deleteCard(_ sender: Any) {
        delegate?.deleteCard(with: self.cardId)
    }

    func updateImageConstraints(isFlexibleSize: Bool) {
        layoutIfNeeded()
        cardImageViewWidthConstraint?.constant = isFlexibleSize ? imageLargeSize.width : imageSmallSize.width
        cardImageViewHeightConstraint?.constant = isFlexibleSize ? imageLargeSize.height : imageSmallSize.height
        cardImageView.contentMode = isFlexibleSize ? .scaleToFill : .scaleAspectFit
        setNeedsDisplay()
        layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if isItemSelected {
                    setupSelectedUI()
                } else {
                    setupDeselectedUI()
                }
            }
        }
    }
}
