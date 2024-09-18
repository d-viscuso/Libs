//
//  HorizontalDiscoverViewModel.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 14/08/2022.
//

import Foundation

/// Dashboard horizontal discover view model
public class HorizontalDiscoverViewModel {
    private let horizontalDiscoverModel: HorizontalDiscoverModel

    /// init HorizontalDiscoverViewModel
    public init(with model: HorizontalDiscoverModel) {
        self.horizontalDiscoverModel = model
    }

    /// discover list
    public var discoverList: [HorizontalDiscoverItemModel]? {
        horizontalDiscoverModel.discoverList
    }

    /// number of items in discover list
    public var numberOfItems: Int {
        horizontalDiscoverModel.discoverList?.count ?? 0
    }

    /// get discover item by index
    public func getDiscoverItemByIndex(index: Int) -> HorizontalDiscoverItemModel? {
        return horizontalDiscoverModel.discoverList?[index]
    }
}
