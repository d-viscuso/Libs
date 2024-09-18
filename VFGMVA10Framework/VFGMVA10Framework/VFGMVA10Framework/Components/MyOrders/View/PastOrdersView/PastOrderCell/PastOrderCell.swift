//
//  PastOrderCell.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 16/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// *PastOrderCell* delegate
protocol PastOrderCellDelegate: AnyObject {
    /// Handle order summary button action
    /// - Parameters:
    ///    - order: Given order to show its summary
    func orderSummaryButtonDidPressed(for order: Order?)
}
/// *PastOrdersViewController* table view cell
class PastOrderCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var orderNumberTitleLabel: VFGLabel!
    @IBOutlet weak var orderSummaryLabel: VFGLabel!
    @IBOutlet weak var orderSummaryImage: VFGImageView!
    @IBOutlet weak var orderSummaryButton: VFGButton!
    @IBOutlet weak var orderNumberLabel: VFGLabel!
    @IBOutlet weak var dateCancelledLabel: VFGLabel!
    @IBOutlet weak var orderIteamsView: UIView!
    @IBOutlet weak var orderItemsStackView: UIStackView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    /// An instance of *Order*
    var order: Order?
    /// An instance of *PastOrderCellDelegate*
    weak var delegate: PastOrderCellDelegate?
    let cellTopConstraintDefaultValue: CGFloat = 16
    let firstCellTopConstraintValue: CGFloat = 32

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAccessibility()
    }

    private func setupAccessibility() {
        orderNumberTitleLabel.isAccessibilityElement = true
        orderSummaryImage.isAccessibilityElement = true
        orderNumberLabel.isAccessibilityElement = true
        dateCancelledLabel.isAccessibilityElement = true
        orderSummaryButton.accessibilityValue = "order summary"
        orderSummaryImage.accessibilityValue = "sheet"
    }

    // MARK: - setup cell
    /// *PastOrderCell* configuration
    /// - Parameters:
    ///    - order: Given order to get item cell data
    ///    - delegate: Determine the delegate for *PastOrderCell*
    func setup(
        with order: Order,
        delegate: PastOrderCellDelegate? = nil,
        isFirstOrder: Bool = false
    ) {
        self.order = order
        orderNumberTitleLabel.text = "my_orders_order_number".localized(bundle: .mva10Framework)
        orderSummaryLabel.text = "my_orders_action_order_summary".localized(bundle: .mva10Framework)
        orderSummaryLabel.textColor = .linksRedText
        orderNumberLabel.text = "\(order.id)"
        if order.state == OrderState.cancelled.rawValue {
            let dateString = VFGDateHelper.changeDateStringFormat(
                dateString: order.dateCancelled ?? "",
                format: "dd MMMM yyyy",
                dateFormatString: Constants.AddOnsTimeline.dateFormat,
                locale: Constants.AddOnsTimeline.localeUS)
            dateCancelledLabel.text = String(
                format: "my_orders_date_cancelled".localized(bundle: .mva10Framework),
                dateString ?? "")
            dateCancelledLabel.isHidden = false
        } else {
            dateCancelledLabel.text = nil
            dateCancelledLabel.isHidden = true
        }
        topConstraint.constant = isFirstOrder ? firstCellTopConstraintValue : cellTopConstraintDefaultValue
        orderIteamsView.configureShadow(radius: 8.0, opacity: 0.16)
        setupOrderItems(with: order.orderItems)
    }

    // MARK: - setup order items
    private func setupOrderItems(with items: [Order.OrderItem]) {
        orderItemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, item) in items.enumerated() {
            guard let pastOrderItemView = PastOrderItemView.loadXib(
                bundle: .mva10Framework,
                nibName: String(describing: PastOrderItemView.self)) as? PastOrderItemView else {
                continue
            }
            pastOrderItemView.setup(with: item)
            if index == items.count - 1 {
                pastOrderItemView.hideBottomSeparator()
            }
            orderItemsStackView.addArrangedSubview(pastOrderItemView)
        }
    }

    // MARK: - Actions
    @IBAction func orderSummaryButtonDidPressed(_ sender: VFGButton) {
        delegate?.orderSummaryButtonDidPressed(for: order)
    }
}
