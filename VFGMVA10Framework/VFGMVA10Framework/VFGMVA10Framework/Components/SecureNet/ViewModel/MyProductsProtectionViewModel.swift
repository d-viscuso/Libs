//
//  MyProductsProtectionViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 19/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// My products protection screen view model
class MyProductsProtectionViewModel: VFGMyProductsProtectionViewModelProtocol {
    /// An instance of  *VFGSecureNetDataProviderProtocol* to fetch data
    var dataProvider: VFGSecureNetDataProviderProtocol?
    internal var productsProtectionModel: VFGMyProductsProtectionModel?
    /// Current loading state
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    /// Action closure for updating loading status
    var updateLoadingStatus: (() -> Void)?

    /// My products protection screen view model initializer
    ///  - Parameters:
    ///     - dataProvider: Given data provider to fetch data
    init(dataProvider: VFGSecureNetDataProviderProtocol?) {
        self.dataProvider = dataProvider
    }

    /// Responsible for handling the result of fetching my products protection data
    func fetchMyProducts() {
        contentState = .loading
        dataProvider?.fetchMyProducts { [weak self] result, error in
            guard error == nil else {
                self?.contentState = .error
                return
            }
            self?.productsProtectionModel = result
            self?.contentState = .populated
        }
    }

    /// A method used to return number of cards in current section for *MyProductsProtectionViewController* table view
    /// - Returns: Number of cards
    func numberOfCards() -> Int {
        guard let count = productsProtectionModel?.cards?.count else {
            return 0
        }
        return count
    }

    /// A method used to return title for section header title of table view
    /// - Returns: Table view title
    func getTitle() -> String {
        guard let title = productsProtectionModel?.title else {
            return ""
        }
        return title
    }

    /// A method used to return subtitle for section header title of table view
    /// - Returns: Table view subtitle
    func getSubTitle() -> String {
        guard let subTitle = productsProtectionModel?.subTitle else {
            return ""
        }
        return subTitle
    }

    /// A method used to return cars details
    /// - Returns: Cards details
    func getCard(at indexPath: IndexPath) -> VFGMyProductsProtectionModel.Card? {
        guard let sections = productsProtectionModel?.cards,
            indexPath.row < sections.count else {
            return nil
        }
        return sections[indexPath.row]
    }
}
