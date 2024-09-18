//
//  VFGMyProductsProtectionViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 20/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// My products protection screen view model
public protocol VFGMyProductsProtectionViewModelProtocol {
    /// An instance of  *VFGSecureNetDataProviderProtocol* to fetch data
    var dataProvider: VFGSecureNetDataProviderProtocol? { get set }
    /// An instance of *VFGMyProductsProtectionModel* represent fetched data
    var productsProtectionModel: VFGMyProductsProtectionModel? { get set }
    /// Current loading state
    var contentState: VFGContentState { get set }
    /// Action closure for updating loading status
    var updateLoadingStatus: (() -> Void)? { get set }

    /// Responsible for handling the result of fetching my products protection data
    func fetchMyProducts()
    /// A method used to return number of cards in current section for *MyProductsProtectionViewController* table view
    /// - Returns: Number of cards
    func numberOfCards() -> Int
    /// A method used to return title for section header title of table view
    /// - Returns: Table view title
    func getTitle() -> String
    /// A method used to return subtitle for section header title of table view
    /// - Returns: Table view subtitle
    func getSubTitle() -> String
    /// A method used to return cars details
    /// - Returns: Cards details
    func getCard(at indexPath: IndexPath) -> VFGMyProductsProtectionModel.Card?
}

extension VFGMyProductsProtectionViewModelProtocol {
    func fetchMyProducts() {}
}
