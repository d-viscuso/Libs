//
//  VFGVerticalSubTrayView+Search.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGVerticalSubTrayView {
    /// Search in category tabs components names for given text to filter list of tabs
    /// - Parameters:
    ///    - query: Text typed in search bar
    ///    - category: Given category to search in it for a match
    func searchProducts(with query: String, in category: VFGVerticalSubTrayViewTabCategoryUIModel) {
        let searchCriteria: (VFGSubTrayItem) -> Bool = {
            $0.title?.localized().lowercased().hasPrefix(query) ?? false ||
            $0.formattedSubTitle?.lowercased().hasPrefix(query) ?? false ||
            $0.phoneNumber?.hasPrefix(query) ?? false
        }
        switch category {
        case .all:
            let filteredProducts = query.isEmpty ? dataModel?.items : dataModel?.items?
                .filter { searchCriteria($0) }
            filteredDataSource?.items = filteredProducts
        case .other(let category):
            var filteredProducts = dataModel?.items?.filter { $0.category?.localized() == category }
            filteredProducts = query.isEmpty ? filteredProducts : filteredProducts?
                .filter { searchCriteria($0) }
            filteredDataSource?.items = filteredProducts
        }
        collectionView?.reloadData()
        collectionView?.setContentOffset(.zero, animated: true)
    }
}
