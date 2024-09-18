//
//  OrderItemModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// My orders item model
public struct OrderItemModel: Codable {
    public let id: Int
    public let orderStatus: OrderItemStatus
    public let deliveryDate, placedDate, updateDate: String
    public let updateTime, deliveryType: String
    public let isInstallation: Bool
}


extension OrderItemModel {
    private var mainStepsKeys: [String] {
        [
            OrderItemStatus.confirmed.orderHeaderTitle,
            OrderItemStatus.dispatched.orderHeaderTitle,
            OrderItemStatus.transit.orderHeaderTitle
        ]
    }

    public var stepsKeys: [String] {
        var stepsKeys = mainStepsKeys
        switch orderStatus {
        case .confirmed, .transit, .dispatched, .collection:
            stepsKeys.append(OrderItemStatus.collection.orderHeaderTitle)
        default:
            stepsKeys.append(OrderItemStatus.delivered.orderHeaderTitle)
        }
        if isInstallation {
            stepsKeys.append(OrderItemStatus.installation.orderHeaderTitle)
        }
        return stepsKeys
    }

    public var currentStep: Int {
        switch orderStatus {
        case .confirmed:
            return 0
        case .dispatched:
            return 1
        case .transit:
            return 2
        case .collection:
            return 3
        case .delivered:
            return 3
        case .installation:
            return 4
        }
    }
}
/// Order delivery type states
public enum DeliveryType {
    case home
    case pickup
}
/// Order item progress states
public enum OrderItemStatus: String, Codable {
    case confirmed
    case dispatched
    case transit
    case collection
    case delivered
    case installation

    var statusDateTitle: String {
        switch self {
        case .installation:
            return "my_orders_installation".localized(bundle: .mva10Framework)
        default:
            return "my_orders_estimated_delivery".localized(bundle: .mva10Framework)
        }
    }

    var statusTitle: String {
        switch self {
        case .confirmed:
            return "order_progress_confirmed_status".localized(bundle: .mva10Framework)
        case .transit:
            return "order_progress_transit_status".localized(bundle: .mva10Framework)
        case .dispatched:
            return "order_progress_dispatched_status".localized(bundle: .mva10Framework)
        case .collection:
            return "order_progress_collection_status".localized(bundle: .mva10Framework)
        case .delivered:
            return "order_progress_delivered_status".localized(bundle: .mva10Framework)
        case .installation:
            return "order_progress_installation_status".localized(bundle: .mva10Framework)
        }
    }

    var orderHeaderTitle: String {
        switch self {
        case .confirmed:
            return "order_progress_timeline_confirmed_title".localized(bundle: .mva10Framework)
        case .transit:
            return "order_progress_timeline_transit_title".localized(bundle: .mva10Framework)
        case .dispatched:
            return "order_progress_timeline_dispatched_title".localized(bundle: .mva10Framework)
        case .collection:
            return "order_progress_timeline_collection_title".localized(bundle: .mva10Framework)
        case .delivered:
            return "order_progress_timeline_delivered_title".localized(bundle: .mva10Framework)
        case .installation:
            return "order_progress_timeline_installation_title".localized(bundle: .mva10Framework)
        }
    }
}
