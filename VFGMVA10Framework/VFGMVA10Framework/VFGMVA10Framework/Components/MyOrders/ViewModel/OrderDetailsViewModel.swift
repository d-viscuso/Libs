//
//  OrderDetailsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 16/12/2021.
//

import Foundation
/// Order details screen view model
class OrderDetailsViewModel {
    /// An instance of  *VFGMyOrdersDataProviderProtocol* to fetch data
    var dataProvider: VFGMyOrdersDataProviderProtocol?
    /// An instance of *OrderItemModel*
    var orderItemModel: OrderItemModel?
    /// Current loading state
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    /// Action closure for updating loading status
    var updateLoadingStatus: (() -> Void)?
    /// Order details screen view model initializer
    ///  - Parameters:
    ///     - dataProvider: Given data provider to fetch data
    init(dataProvider: VFGMyOrdersDataProviderProtocol? = VFGMyOrdersManager.shared.dataProvider) {
        self.dataProvider = dataProvider
    }
    /// Responsible for handling the result of fetching order details data
    /// - Parameters:
    ///    - orderId: Order id number
    ///    - itemId: Order item id number
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchOrderItem(orderId: String, itemId: String, completion: (() -> Void)? = nil) {
        dataProvider?.fetchOrderDetail(orderId: orderId, itemId: itemId) { [weak self] orderItemModel, _ in
            guard let itemModel = orderItemModel else {
                self?.contentState = .error
                return
            }
            self?.orderItemModel = itemModel
            self?.contentState = .populated
            completion?()
        }
    }
}
