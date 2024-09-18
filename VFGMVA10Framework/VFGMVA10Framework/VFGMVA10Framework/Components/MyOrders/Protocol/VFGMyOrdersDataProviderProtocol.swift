//
//  VFGMyOrdersDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Data provider protocol for my orders journey
public protocol VFGMyOrdersDataProviderProtocol {
    /// Responsible for handling the result of fetching orders data
    /// - Parameters:
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchOrders(completion: @escaping (OrdersHistoryModel?, Error?) -> Void)
    /// Responsible for handling the result of fetching past orders data
    /// - Parameters:
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchPastOrders(completion: @escaping (OrdersHistoryModel?, Error?) -> Void)
    /// Responsible for handling the result of fetching order details data
    /// - Parameters:
    ///    - orderId: Order id number
    ///    - itemId: Order item id number
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchOrderDetail(
        orderId: String,
        itemId: String,
        completion: @escaping (OrderItemModel?, Error?) -> Void
    )

    /// Number of inProgress orders.
    var numberOfInProgressOrders: Int { get }
}
