//
//  VFGCTACardsViewModel.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 1/16/23.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// VFGCTACardsViewModel
public class VFGCTACardsViewModel {
    /// Refreshing protocol for updating displayed cards
    var refreshDelegate: VFGCTACardsViewRefreshProtocol?
    /// Model for holding cards and their layout type
    private var cardModel: BannerCTACardModel
    /// Action delegate for card selection
    private weak var delegate: BannerCTACardDelegate?
    /// Description to show at the top
    public var descriptionText: String

    public init(
        cardModel: BannerCTACardModel,
        delegate: BannerCTACardDelegate?,
        descriptionText: String
    ) {
        self.cardModel = cardModel
        self.delegate = delegate
        self.descriptionText = descriptionText
    }
}

extension VFGCTACardsViewModel: VFGCTACardsViewProtocol {
    /// Updates current cardModel with a new one
    /// Allows adding/removing cards from the displayed cards list
    public func changeCardModel(with cardModel: BannerCTACardModel) {
        self.cardModel = cardModel
        refreshDelegate?.refreshCards()
    }

    public func getLayoutType() -> BannerCTACardType {
        return cardModel.type
    }

    public func getBannerCTACardDelegate() -> BannerCTACardDelegate? {
        return delegate
    }

    public func getCardItem(for indexPath: IndexPath) -> BannerCTACardItemModel? {
        if cardModel.cards.count > indexPath.row {
            return cardModel.cards[indexPath.row]
        }
        return nil
    }

    public func getNumberOfCards() -> Int {
        return cardModel.cards.count
    }
}
