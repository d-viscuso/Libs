//
//  HorizontalCarouselCardsDataSource.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 15/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A data source protocol that manages the data in your horizontal carousel component.
/// It represents your data model and vends information to the horizontal carousel view as needed.
/// It creates and configures the horizontal carousel view to display your data.
public protocol HorizontalCarouselCardsDataSource: AnyObject {
    /// Provide number of cards which is viewed across horizontal carousel view component.
    /// - Parameters:
    ///   - view: Current horizontal carousel view associated with the data source.
    ///   - collectionView: An instance of type *UICollectionView* which you should use to register new cell.
    /// - Returns: An *Int* value which represents number of cards populated through horizontal carousel view.
    func numberOfCards(
        _ view: HorizontalCarouselCardsView,
        in collectionView: UICollectionView
    ) -> Int
    /// Provide a cell at a specific index by using cells provided by horizontal carousel component or register a new cell through *registerCells(_:in:)* and use it through this callback.
    /// - Parameters:
    ///   - view:
    ///   - collectionView: An instance of type *UICollectionView* which you should use to register new cell.
    ///   - indexPath: An *Int* value used to specify a cell at that index.
    /// - Returns: An instance of type *UICollectionViewCell* which represents the cell at given index.
    func horizontalCarouselView(
        _ view: HorizontalCarouselCardsView,
        _ collectionView: UICollectionView,
        cardForItemAt indexPath: IndexPath
    ) -> BaseLargeWidthBannerCellProtocol?
}
