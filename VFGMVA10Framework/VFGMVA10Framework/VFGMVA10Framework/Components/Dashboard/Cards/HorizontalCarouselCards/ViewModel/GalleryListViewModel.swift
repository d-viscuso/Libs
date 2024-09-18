//
//  GalleryListViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 04/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// Gallery list component view model.
public class GalleryListViewModel {
    let cards: [HorizontalCardModel]
    let delegate: GalleryListViewModelDelegate?

    /// Gallery list view model constructor.
    /// - Parameter model: Gallery list cards model.
    public init(
        model: HorizontalCardsModel,
        delegate: GalleryListViewModelDelegate? = nil
    ) {
        cards = model.cards ?? []
        self.delegate = delegate
    }
}

extension GalleryListViewModel: GalleryListViewDataSource {
    public func numberOfCards(_ view: GalleryListCustomView, in collectionView: UICollectionView) -> Int {
        cards.count
    }

    public func galleryList(_ view: GalleryListCustomView, _ collectionView: UICollectionView, cardForItemAt indexPath: IndexPath) -> BaseBannerCellProtocol? {
        let card = cards[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: card.type,
            for: indexPath) as? BaseBannerCellProtocol
        else { return nil }
        cell.bannerActions = delegate?.galleryListActions()
        cell.actionsDelegate = delegate?.actionsDelegate
        cell.configure(with: card)
        delegate?.galleryList(
            collectionView,
            configure: cell,
            with: card,
            at: indexPath)
        return cell
    }
}
