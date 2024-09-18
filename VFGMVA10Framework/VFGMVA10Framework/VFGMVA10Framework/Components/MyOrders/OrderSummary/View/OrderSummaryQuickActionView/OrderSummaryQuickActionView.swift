//
//  OrderSummaryQuickActionView.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 16/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Quick action view for order summary
class OrderSummaryQuickActionView: UIView {
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var orderNumberLabel: VFGLabel!
    @IBOutlet weak var orderStateLabel: VFGLabel!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var orderTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalToPayLabel: VFGLabel!
    @IBOutlet weak var upfrontLabel: VFGLabel!
    @IBOutlet weak var upfrontValueLabel: VFGLabel!
    @IBOutlet weak var monthlyLabel: VFGLabel!
    @IBOutlet weak var monthlyValueLabel: VFGLabel!

    var contentViewMinHeight: CGFloat = 350
    var orderTableViewMinHeight: CGFloat = 146
    var contentViewMaxHeight: CGFloat = 516
    var orderTableViewMaxHeight: CGFloat = 332
    /// An instance of *Order* model
    var order: Order?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
        registerCell()
    }

    private func setupUI() {
        totalToPayLabel.text = "my_orders_summary_total_to_pay".localized(bundle: .mva10Framework)
        upfrontLabel.text = "my_orders_summary_upfront".localized(bundle: .mva10Framework)
    }

    private func registerCell() {
        orderTableView.register(
            UINib(
                nibName: String(describing: OrderSummaryQuickActionCell.self),
                bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: OrderSummaryQuickActionCell.self))
        orderTableView.isAccessibilityElement = false
    }
    /// *OrderSummaryQuickActionView* configuration
    /// - Parameters:
    ///    - order: Quick action view data model
    func configure(for order: Order) {
        self.order = order

        let unit = order.pricePlan.unit
        orderNumberLabel.text = "\(order.id)"
        orderStateLabel.text = OrderState(rawValue: order.state)?.orderSummaryStatus
        let upfrontValue = "\(order.pricePlan.upfront)" + unit
        upfrontValueLabel.text = upfrontValue
        let monthyTotal = "my_orders_summary_total_to_pay_monthly_total".localized(bundle: .mva10Framework)
        let monthsCount = "\(order.pricePlan.monthsCount)"
        let monthyTotalText = String(format: monthyTotal, monthsCount)
        monthlyLabel.text = monthyTotalText
        let monthlyValue = "\(order.pricePlan.perMonth)" + unit
        monthlyValueLabel.text = monthlyValue

        contentViewHeight.constant = order.orderItems.count > 1 ? contentViewMaxHeight : contentViewMinHeight
        orderTableViewHeight.constant = order.orderItems.count > 1 ? orderTableViewMaxHeight : orderTableViewMinHeight

        orderTableView.reloadData()
    }
}

extension OrderSummaryQuickActionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        order?.orderItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let orderItemsCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: OrderSummaryQuickActionCell.self),
                for: indexPath) as? OrderSummaryQuickActionCell else {
            return UITableViewCell()
        }

        guard let orderItem = order?.orderItems[indexPath.row] else {
            return UITableViewCell()
        }

        orderItemsCell.configure(with: orderItem)
        return orderItemsCell
    }
}
