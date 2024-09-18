//
//  OrderSummaryQuickActionCell.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 16/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Quick action cell for order summary item
class OrderSummaryQuickActionCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var itemImageView: VFGImageView!
    @IBOutlet weak var upfrontLabel: VFGLabel!
    @IBOutlet weak var upfrontValueLabel: VFGLabel!
    @IBOutlet weak var monthlyLabel: VFGLabel!
    @IBOutlet weak var monthlyValueLabel: VFGLabel!
    @IBOutlet weak var totalCostLabel: VFGLabel!
    @IBOutlet weak var totalCostValueLabel: VFGLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupAccessibility()
        setupUI()
    }

    private func setupAccessibility() {
        categoryLabel.isAccessibilityElement = true
        titleLabel.isAccessibilityElement = true
        itemImageView.isAccessibilityElement = true
        upfrontLabel.isAccessibilityElement = true
        upfrontValueLabel.isAccessibilityElement = true
        monthlyLabel.isAccessibilityElement = true
        monthlyValueLabel.isAccessibilityElement = true
        totalCostLabel.isAccessibilityElement = true
        totalCostValueLabel.isAccessibilityElement = true
    }

    private func setupUI() {
        upfrontLabel.text = "my_orders_summary_upfront".localized(bundle: .mva10Framework)
        totalCostLabel.text = "my_orders_summary_total_device_cost".localized(bundle: .mva10Framework)
    }
    /// *OrderSummaryQuickActionCell* configuration
    /// - Parameters:
    ///    - orderItem: Quick action cell data model
    func configure(with orderItem: Order.OrderItem) {
        categoryLabel.text = orderItem.category
        titleLabel.text = orderItem.title
        itemImageView.image = VFGImage(named: orderItem.image)
        itemImageView.accessibilityValue = orderItem.imageAccessibilityDescription

        let unit = orderItem.pricePlan.unit
        let upfrontValue = "\(orderItem.pricePlan.upfront)" + unit
        upfrontValueLabel.text = upfrontValue
        let monthyTotal = "my_orders_summary_total_to_pay_monthly".localized(bundle: .mva10Framework)
        let monthsCount = "\(orderItem.pricePlan.monthsCount)"
        let monthyTotalText = String(format: monthyTotal, monthsCount)
        monthlyLabel.text = monthyTotalText
        let monthlyValue = "\(orderItem.pricePlan.perMonth)" + unit
        monthlyValueLabel.text = monthlyValue
        let totalCostValue = "\(orderItem.pricePlan.totalAmount)" + unit
        totalCostValueLabel.text = totalCostValue
    }
}
