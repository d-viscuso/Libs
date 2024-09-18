//
//  OrderSummaryQuickActionModel.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 16/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// A quick action model to display order summary
public class OrderSummaryQuickActionModel: VFQuickActionsModel {
    /// An instance of *Order* model
    var order: Order
    /// A delegation between *VFQuickActionsViewController* and *OrderSummaryQuickActionModel*
    weak var delegate: VFQuickActionsProtocol?
    public var quickActionsTitle: String = ""
    public var quickActionsStyle: VFQuickActionsStyle = .white

    public var customHeaderView: UIView? {
        guard let orderSummaryQuickActionHeader: OrderSummaryQuickActionHeader =
            UIView.loadXib(bundle: .mva10Framework) else {
            return UIView()
        }
        return orderSummaryQuickActionHeader
    }

    public var quickActionsContentView: UIView {
        guard let orderSummaryQuickActionView: OrderSummaryQuickActionView =
            UIView.loadXib(bundle: .mva10Framework) else {
            return UIView()
        }
        orderSummaryQuickActionView.configure(for: order)
        return orderSummaryQuickActionView
    }
    /// Order summary initializer
    /// - Parameters:
    ///    - order: Given order to display its summary
    public init(order: Order) {
        self.order = order
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }

    public func closeQuickAction() {
        delegate?.closeQuickAction(completion: nil)
    }
}
