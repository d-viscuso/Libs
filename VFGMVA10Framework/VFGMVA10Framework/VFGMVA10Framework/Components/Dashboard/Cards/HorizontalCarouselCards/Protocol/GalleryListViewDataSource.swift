//
//  GalleryListViewDataSource.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 04/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

/// A data source protocol that manages the data in your gallery list component.
/// It represents your data model and vends information to the gallery list view as needed.
/// It creates and configures the gallery list view to display your data.
public protocol GalleryListViewDataSource: AnyObject {
    /// Provide number of cards which is viewed across gallery list view component.
    /// - Parameters:
    ///   - view: Current gallery list view associated with the data source.
    ///   - collectionView: An instance of type *UICollectionView* which you should use to register new cell.
    /// - Returns: An *Int* value which represents number of cards populated through gallery list view.
    func numberOfCards(
        _ view: GalleryListCustomView,
        in collectionView: UICollectionView
    ) -> Int
    /// Provide a cell at a specific index by using cells provided by gallery list component or register a new cell through *registerCells(_:forCellWithReuseIdentifier:)* and use it through this callback.
    /// - Parameters:
    ///   - view: Current gallery list view associated with the data source.
    ///   - collectionView: An instance of type *UICollectionView* which represents the collection view instance used to show your provided cells.
    ///   - indexPath: An *Int* value used to specify a cell at that index.
    /// - Returns: An instance of type *UICollectionViewCell* which conforms to *BaseBannerCellProtocol* and represents the cell at given index.
    func galleryList(
        _ view: GalleryListCustomView,
        _ collectionView: UICollectionView,
        cardForItemAt indexPath: IndexPath
    ) -> BaseBannerCellProtocol?
}
