//
//  OrdersHistoryModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - OrdersHistory
/// My orders history model
public struct OrdersHistoryModel: Codable {
    let orders: [Order]
}

// MARK: - Order
/// Order model
public struct Order: Codable {
    let id: Int
    let orderDate, state: String
    let dateCancelled: String?
    let pricePlan: PricePlan
    let orderItems: [OrderItem]

    // MARK: - OrderItem
    struct OrderItem: Codable {
        let id: Int
        let title, category, status: String
        let isInstallation: Bool
        let image: String?
        let imageAccessibilityDescription: String?
        let date: String
        let dateCompleted: String?
        let startTime, endTime: String?
        let updateDate, updateTime: String
        let pricePlan: PricePlan
    }

    // MARK: - PricePlan
    struct PricePlan: Codable {
        let upfront, perMonth, monthsCount, totalAmount: Int
        let unit: String
    }
}
/// Order progress states
public enum OrderState: String {
    case inProgress = "In progress"
    case completed = "Completed"
    case cancelled = "Cancelled"

    var orderSummaryStatus: String {
        switch self {
        case .inProgress:
            return "my_orders_inprogress".localized(bundle: .mva10Framework)
        case .completed:
            return "order_progress_completed_status".localized(bundle: .mva10Framework)
        case .cancelled:
            return "order_progress_cancelled_status".localized(bundle: .mva10Framework)
        }
    }
}
