//
//  VFGPaymentMethodsCardView+UICollectionView.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 06/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGPaymentMethodsCardView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard cardsPreviewMode == .large else {
            return shownPaymentCards.count + 1
        }
        return shownPaymentCards.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch cardsPreviewMode {
        case .large:
            cell = expandedCollection(collectionView, cellForItemAt: indexPath)
        case .compact:
            if indexPath.row < shownPaymentCards.count {
                cell = compactCollection(collectionView, cellForItemAt: indexPath)
            } else {
                cell = emptyCollection(collectionView, cellForItemAt: indexPath)
            }
        case .empty:
            cell = emptyCollection(collectionView, cellForItemAt: indexPath)
        }
        return cell
    }

    func emptyCollection(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let addPaymentCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: addPaymentMethodCellId,
            for: indexPath) as? VFGAddPaymentMethodCell else { return UICollectionViewCell() }
        let paymentMethodText = "top_up_quick_action_add_payment_method_item_text".localized(
            bundle: Bundle.mva10Framework
        )
        addPaymentCell.config(labelText: paymentMethodText)
        return addPaymentCell
    }

    func expandedCollection(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let largeCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: paymentMethodLargeCellId,
            for: indexPath) as? VFGPaymentMethodLargeCell else { return UICollectionViewCell() }

        let cardModel = shownPaymentCards[indexPath.row]
        let cardNumber = cardModel.securedDigits

        var cardImage: UIImage?
        if let cardImageData = cardModel.cardImageData, let cardImageFromData = UIImage(data: cardImageData) {
            cardImage = cardImageFromData
        } else {
            cardImage = VFGImage(named: cardModel.cardImageName)
        }

        largeCell.configure(with: VFGPaymentMethodCellViewModel(
            cardImage: cardImage,
            cardName: cardModel.nameOnCard,
            cardNumber: cardNumber,
            cardExpiryDate: cardModel.formatExpiryDate()))
        return largeCell
    }

    func compactCollection(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let compactCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: paymentMethodCompactCellId,
            for: indexPath) as? VFGPaymentMethodCompactCell else { return UICollectionViewCell() }

        compactCell.delegate = self
        let cardModel = shownPaymentCards[indexPath.row]
        let cardNumber = cardModel.hideCardNumberWithText()

        var cardImage: UIImage?
        if let cardImageData = cardModel.cardImageData, let cardImageFromData = UIImage(data: cardImageData) {
            cardImage = cardImageFromData
        } else {
            cardImage = VFGImage(named: cardModel.cardImageName)
        }

        compactCell.configure(
            with: VFGPaymentMethodCellViewModel(
                cardImage: cardImage,
                cardName: cardModel.nameOnCard,
                cardNumber: cardNumber,
                cardExpiryDate: cardModel.formatExpiryDate()),
            and: cardModel.cardId,
            showDeleteButton: VFGPaymentManager.showDeleteButton
        )
        compactCell.isItemSelected = indexPath.row == 0
        compactCell.accessibilityIdentifier = "TPpaymentCompactCardView\(indexPath.row)"
        return compactCell
    }
}

extension VFGPaymentMethodsCardView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard cardsPreviewMode != .large else { return }
        if indexPath.row == shownPaymentCards.count {
            switch presenterType {
            case .topUp:
                VFGPaymentManager.topupStateManager?.addNewPayment(didPurchaseGift: didPurchaseGift)
            case .billing:
                VFGPaymentManager.payBillStateManager?.addNewPayment()
            case .addPlan:
                VFGPaymentManager.addPlanStateManager?.addNewPayment()
            case .autoBill:
                VFGPaymentManager.autoBillStateManager?.addNewPayment()
            case .autoTopUp:
                VFGPaymentManager.autoTopUpStateManager?.addNewCard()
            }
        } else {
            lastSelectedCardIndex = indexPath.row
            showSelected(card: paymentCards[indexPath.row])
        }
        changeCollectionHeightWithLargeMode()
    }

    private func changeCollectionHeightWithLargeMode() {
        if cardsPreviewMode == .large {
            paymentCardsCollectionHeightConstraint.constant = collectionHeightWhenCardSelected
        }
    }
}

extension VFGPaymentMethodsCardView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sideMargins: CGFloat = 32
        let titleLabelSize = titleLabel.text?.size(with: titleLabel.font) ?? .zero
        let titleHeightWithConstant = titleLabelSize.height * 2 + titleLabelBottomConstraint.constant
        switch cardsPreviewMode {
        case .large:
            collectionViewDelegate?.collectionView(
                collectionView,
                didHeightChanged: estimatedLargeCellHeight,
                viewHeight: estimatedLargeCellHeight + titleHeightWithConstant)
            return CGSize(
                width: collectionView.frame.width - sideMargins,
                height: estimatedLargeCellHeight)
        case .empty where VFGPaymentManager.emptyCardsPreviewMode == .large:
            collectionViewDelegate?.collectionView(
                collectionView,
                didHeightChanged: estimatedCompactCellSize.height,
                viewHeight: estimatedCompactCellSize.height + titleHeightWithConstant)
            return CGSize(
                width: collectionView.frame.width - sideMargins,
                height: estimatedCompactCellSize.height)
        default:
            collectionViewDelegate?.collectionView(
                collectionView,
                didHeightChanged: estimatedCompactCellSize.height,
                viewHeight: estimatedCompactCellSize.height + titleHeightWithConstant
            )
            return CGSize(
                width: estimatedCompactCellSize.width,
                height: estimatedCompactCellSize.height)
        }
    }
}
