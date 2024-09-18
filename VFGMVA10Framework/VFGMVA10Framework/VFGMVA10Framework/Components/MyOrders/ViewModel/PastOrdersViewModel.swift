//
//  PastOrdersViewModel.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 16/01/2022.
//

import Foundation
/// IPast orders screen view model
class PastOrdersViewModel {
    /// An instance of  *VFGMyOrdersDataProviderProtocol* to fetch data
    var dataProvider: VFGMyOrdersDataProviderProtocol?
    /// An array of *Order*
    var pastOrders: [Order] = []
    /// Current loading state
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    /// Action closure for updating loading status
    var updateLoadingStatus: (() -> Void)?
    /// Past orders screen view model initializer
    ///  - Parameters:
    ///     - dataProvider: Given data provider to fetch data
    init(dataProvider: VFGMyOrdersDataProviderProtocol?) {
        self.dataProvider = dataProvider
    }
    /// Responsible for handling the result of fetching past orders data
    /// - Parameters:
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchPastOrders(completion: (() -> Void)? = nil) {
        contentState = .loading
        dataProvider?.fetchPastOrders { [weak self] ordersHistoryModel, _ in
            guard let orders = ordersHistoryModel?.orders else {
                self?.contentState = .error
                return
            }
            self?.pastOrders = orders
            self?.contentState = .populated
            completion?()
        }
    }
    /// Return number of sections for *PastOrdersViewController* table view
    func numberOfSections() -> Int {
        pastOrders.isEmpty ? 0 : 1
    }
    /// Return number of order items in current section for *PastOrdersViewController* table view
    func numberOfItems(in section: Int) -> Int {
        pastOrders.count
    }
    /// Return order item details for *PastOrdersViewController* table view
    func getItem(at indexPath: IndexPath) -> Order? {
        guard indexPath.row < pastOrders.count else {
            return nil
        }
        return pastOrders[indexPath.row]
    }
}
