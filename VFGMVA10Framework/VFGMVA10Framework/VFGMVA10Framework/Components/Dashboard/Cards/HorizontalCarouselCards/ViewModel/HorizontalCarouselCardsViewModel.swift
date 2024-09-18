//
//  HorizontalCarouselCardsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 05/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// Horizontal carousel cards view model.
public class HorizontalCarouselCardsViewModel {
    let cards: [HorizontalCardModel]
    let delegate: HorizontalCarouselViewModelDelegate?

    /// Horizontal carousel cards view model constructor.
    /// - Parameter model: horizontal carousel cards model.
    public init(
        model: HorizontalCardsModel,
        delegate: HorizontalCarouselViewModelDelegate? = nil
    ) {
        cards = model.cards ?? []
        self.delegate = delegate
    }
}

extension HorizontalCarouselCardsViewModel: HorizontalCarouselCardsDataSource {
    public func numberOfCards(_ view: HorizontalCarouselCardsView, in collectionView: UICollectionView) -> Int {
        cards.count
    }

    public func horizontalCarouselView(_ view: HorizontalCarouselCardsView, _ collectionView: UICollectionView, cardForItemAt indexPath: IndexPath) -> BaseLargeWidthBannerCellProtocol? {
        let card = cards[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: card.type,
            for: indexPath) as? BaseLargeWidthBannerCellProtocol
        else { return nil }
        cell.bannerActions = delegate?.carouselCardsActions()
        cell.actionsDelegate = delegate?.actionsDelegate
        cell.configure(with: card)
        delegate?.horizontalCarousel(
            collectionView,
            configure: cell,
            with: card,
            at: indexPath)
        return cell
    }
}
