//
//  InProgressOrdersViewModel.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 04/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// In progress orders screen view model
class InProgressOrdersViewModel {
    /// An instance of  *VFGMyOrdersDataProviderProtocol* to fetch data
    var dataProvider: VFGMyOrdersDataProviderProtocol?
    /// An array of *Order*
    var inProgressOrders: [Order] = []
    /// Current loading state
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    /// Action closure for updating loading status
    var updateLoadingStatus: (() -> Void)?
    /// In progress orders screen view model initializer
    ///  - Parameters:
    ///     - dataProvider: Given data provider to fetch data
    init(dataProvider: VFGMyOrdersDataProviderProtocol?) {
        self.dataProvider = dataProvider
    }
    /// Responsible for handling the result of fetching in progress orders data
    /// - Parameters:
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchOrders(completion: (() -> Void)? = nil) {
        contentState = .loading
        dataProvider?.fetchOrders { [weak self] ordersHistoryModel, _ in
            guard let orders = ordersHistoryModel?.orders else {
                self?.contentState = .error
                return
            }
            self?.inProgressOrders = orders.filter { $0.state == OrderState.inProgress.rawValue }
            if self?.inProgressOrders.isEmpty ?? true {
                self?.contentState = .empty
            } else {
                self?.contentState = .populated
            }
            completion?()
        }
    }
    /// Return number of sections for *InProgressOrdersViewController* table view
    func numberOfSections() -> Int {
        inProgressOrders.count
    }
    /// Return number of order items in current section for *InProgressOrdersViewController* table view
    func numberOfItems(in section: Int) -> Int {
        guard section < inProgressOrders.count else {
            return 0
        }
        return inProgressOrders[section].orderItems.count
    }
    /// Return order details in current section for *InProgressOrdersViewController* table view
    func getItem(for section: Int) -> Order? {
        guard section < inProgressOrders.count else {
            return nil
        }
        return inProgressOrders[section]
    }
    /// Return order item details for *InProgressOrdersViewController* table view
    func getItem(at indexPath: IndexPath) -> Order.OrderItem? {
        guard indexPath.section < inProgressOrders.count,
            indexPath.row < inProgressOrders[indexPath.section].orderItems.count else {
            return nil
        }
        return inProgressOrders[indexPath.section].orderItems[indexPath.row]
    }
}
