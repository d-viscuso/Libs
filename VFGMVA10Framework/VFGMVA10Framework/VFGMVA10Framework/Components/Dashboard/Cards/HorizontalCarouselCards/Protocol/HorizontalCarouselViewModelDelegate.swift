//
//  HorizontalCarouselViewModelDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 05/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

/// A delegate protocol that manages interactions with each horizontal carousel card.
public protocol HorizontalCarouselViewModelDelegate: AnyObject {
    /// An instance of type *HorizontalBannersActionsDelegate* which represents the delegate for each view action in horizontal carousel.
    var actionsDelegate: HorizontalBannersActionsDelegate? { get }
    /// A callback which is used to return actions for each view in horizontal carousel.
    /// - Returns: A dictionary which represents a list of keys and actions.
    func carouselCardsActions() -> [String: (HorizontalCardModel) -> Void]
    /// A callback which is used to configure a specific behaviour for a specific cell.
    /// - Parameters:
    ///   - collectionView: An instance of type *UICollectionView* which represents the collection view instance used to show your provided cells.
    ///   - cell: An instance of type *UICollectionViewCell* which represents the cell at specific index.
    ///   - model: An instance of type *HorizontalCardModel* which represents the model for cell at specific index.
    ///   - indexPath: An instance of type *IndexPath* value used to specify a cell at that index.
    func horizontalCarousel(
        _ collectionView: UICollectionView,
        configure cell: UICollectionViewCell,
        with model: HorizontalCardModel,
        at indexPath: IndexPath
    )
}

extension HorizontalCarouselViewModelDelegate {
    public var actionsDelegate: HorizontalBannersActionsDelegate? { nil }
    public func carouselCardsActions() -> [String: (HorizontalCardModel) -> Void] { return [:] }
    public func horizontalCarousel(
        _ collectionView: UICollectionView,
        configure cell: UICollectionViewCell,
        with model: HorizontalCardModel,
        at indexPath: IndexPath
    ) {}
}
