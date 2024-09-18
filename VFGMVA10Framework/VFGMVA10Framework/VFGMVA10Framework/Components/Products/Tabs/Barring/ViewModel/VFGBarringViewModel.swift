//
//  VFGBarringViewModel.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 18/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Barring view model
public class VFGBarringViewModel: VFGBarringViewModelProtocol {
    public var barringDetails: [VFGBarringItemViewModel]?
    public var dataProvider: VFGBarringDataProviderProtocol?
    public var viewDetails: VFGBarringProtocol?
    public var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    public var updateLoadingStatus: (() -> Void)?

    public init(dataProvider: VFGBarringDataProviderProtocol?, viewDetails: VFGBarringProtocol? = nil) {
        self.dataProvider = dataProvider
        self.viewDetails = viewDetails
    }

    public func fetchBarringDetails() {
        contentState = .loading
        dataProvider?.fetchBarringDetails { [weak self] permissions, error in
            guard let self = self else { return }
            if error != nil {
                self.contentState = .error
                return
            }
            guard let permissions = permissions else {
                self.contentState = .error
                return
            }

            self.barringDetails = permissions
            self.contentState = .populated
        }
    }
    public func numberOfBarrings() -> Int {
        barringDetails?.count ?? 0
    }
}
