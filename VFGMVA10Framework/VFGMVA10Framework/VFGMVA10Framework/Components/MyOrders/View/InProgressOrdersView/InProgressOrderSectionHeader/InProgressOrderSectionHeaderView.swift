//
//  InProgressOrderSectionHeaderView.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 03/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// *InProgressOrderSectionHeaderView* delegate
protocol InProgressOrderSectionHeaderViewDelegate: AnyObject {
    /// Handle order summary button action
    /// - Parameters:
    ///    - order: Given order to show its summary
    func orderSummaryButtonDidPressed(for order: Order?)
}
/// *InProgressOrdersViewController* table view header view
class InProgressOrderSectionHeaderView: UITableViewHeaderFooterView {
    // MARK: - Outlets
    @IBOutlet weak var orderNumberTitleLabel: VFGLabel!
    @IBOutlet weak var orderSummaryLabel: VFGLabel!
    @IBOutlet weak var orderSummaryIconImage: VFGImageView!
    @IBOutlet weak var orderSummaryButton: VFGButton!
    @IBOutlet weak var orderNumberLabel: VFGLabel!
    @IBOutlet weak var placeDateLabel: VFGLabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    /// An instance of *Order*
    var order: Order?
    /// An instance of *InProgressOrderSectionHeaderViewDelegate*
    weak var delegate: InProgressOrderSectionHeaderViewDelegate?
    let headerTopConstraintDefaultValue: CGFloat = 16
    let firstHeaderTopConstraintValue: CGFloat = 32

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAccessibility()
    }

    private func setupAccessibility() {
        orderSummaryButton.accessibilityValue = "order summary"
        orderSummaryIconImage.accessibilityValue = "sheet"
    }

    // MARK: - setup
    /// *InProgressOrderSectionHeaderView* configuration
    /// - Parameters:
    ///    - order: Given order to get header view data
    ///    - delegate: Determine the delegate for *InProgressOrderSectionHeaderView*
    func setup(
        order: Order,
        delegate: InProgressOrderSectionHeaderViewDelegate? = nil,
        isFirstOrder: Bool = false
    ) {
        self.order = order
        self.delegate = delegate
        orderNumberTitleLabel.text = "my_orders_order_number".localized(bundle: .mva10Framework)
        orderNumberLabel.text = "\(order.id)"
        orderSummaryLabel.text = "my_orders_action_order_summary".localized(bundle: .mva10Framework)
        orderSummaryLabel.textColor = .linksRedText
        let dateString = VFGDateHelper.changeDateStringFormat(
            dateString: order.orderDate,
            format: "dd MMMM yyyy",
            dateFormatString: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
        placeDateLabel.text = String(
            format: "my_orders_order_placed_title".localized(bundle: .mva10Framework),
            dateString ?? "")
        topConstraint.constant = isFirstOrder ? firstHeaderTopConstraintValue : headerTopConstraintDefaultValue
    }

    // MARK: - Actions
    @IBAction func orderSummaryButtonDidPressed(_ sender: VFGButton) {
        delegate?.orderSummaryButtonDidPressed(for: order)
    }
}
