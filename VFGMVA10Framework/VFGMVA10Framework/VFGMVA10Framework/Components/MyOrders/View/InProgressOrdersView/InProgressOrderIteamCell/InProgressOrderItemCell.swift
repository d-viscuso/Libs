//
//  InProgressOrderItemCell.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 03/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// *InProgressOrderItemCell* delegate
protocol InProgressOrderItemCellDelegate: AnyObject {
    /// Edit button action
    /// - Parameters:
    ///    - currentIndexPath: Edit button index path
    func editButtonDidPressed(currentIndexPath: IndexPath)
    /// Navigate to *VFGOrderDetailsViewController*
    /// - Parameters:
    ///    - currentIndexPath: Order index path
    func navigateToOrderDetails(currentIndexPath: IndexPath)
}

extension InProgressOrderItemCellDelegate {
    func navigateToOrderDetails(currentIndexPath: IndexPath) {}
}
/// *InProgressOrdersViewController* table view item cell
class InProgressOrderItemCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var itemContainerView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editLabel: VFGLabel!
    @IBOutlet weak var editIconImage: VFGImageView!
    @IBOutlet weak var editButton: VFGButton!
    @IBOutlet weak var itemImage: VFGImageView!
    @IBOutlet weak var statusLabel: VFGLabel!
    @IBOutlet weak var statusTypeLabel: VFGLabel!
    @IBOutlet weak var statusDateTitleLabel: VFGLabel!
    @IBOutlet weak var statusDateLabel: VFGLabel!
    @IBOutlet weak var timeLabel: VFGLabel!
    @IBOutlet weak var lastUpdatedDateLabel: VFGLabel!
    @IBOutlet weak var navigationButton: VFGButton!
    /// An instance of *InProgressOrderItemCellDelegate*
    weak var delegate: InProgressOrderItemCellDelegate?
    /// Order item id number
    var itemID: Int?
    /// *InProgressOrderItemCell* index path
    public var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAccessibility()
    }

    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        editIconImage.isAccessibilityElement = true
        itemImage.isAccessibilityElement = true
        statusLabel.isAccessibilityElement = true
        statusTypeLabel.isAccessibilityElement = true
        statusDateTitleLabel.isAccessibilityElement = true
        statusDateLabel.isAccessibilityElement = true
        timeLabel.isAccessibilityElement = true
        lastUpdatedDateLabel.isAccessibilityElement = true
        editButton.accessibilityValue = "edit"
        navigationButton.accessibilityValue = "navigate to order detail"
        editIconImage.accessibilityValue = "pencil"
    }

    // MARK: - setup
    /// *InProgressOrderItemCell* configuration
    /// - Parameters:
    ///    - order: Given order to get item cell data
    ///    - delegate: Determine the delegate for *InProgressOrderItemCell*
    func setup(orderItem: Order.OrderItem, delegate: InProgressOrderItemCellDelegate? = nil) {
        itemID = orderItem.id
        self.delegate = delegate
        itemContainerView.configureShadow(radius: 8.0, opacity: 0.16)
        titleLabel.text = orderItem.title
        editLabel.text = "my_orders_action_edit".localized(bundle: .mva10Framework)
        editLabel.textColor = .linksRedText
        itemImage.image = VFGImage(named: orderItem.image)
        statusLabel.text = "my_orders_status".localized(bundle: .mva10Framework)
        statusTypeLabel.text = OrderItemStatus(rawValue: orderItem.status)?.statusTitle
        statusDateTitleLabel.text = OrderItemStatus(rawValue: orderItem.status)?.statusDateTitle
        statusDateLabel.text = getStatusDate(with: orderItem)
        if let start = orderItem.startTime,
            let end = orderItem.endTime,
            !start.isEmpty, !end.isEmpty {
            timeLabel.text = "\(start) - \(end)"
        } else {
            timeLabel.text = nil
        }
        lastUpdatedDateLabel.text = String(
            format: "my_orders_last_updated_title".localized(bundle: .mva10Framework),
            "my_orders_today".localized(bundle: .mva10Framework),
            orderItem.updateTime)
        itemImage.accessibilityValue = orderItem.imageAccessibilityDescription
    }
    @IBAction func navigationTileAreaDidPress(_ sender: Any) {
        delegate?.navigateToOrderDetails(currentIndexPath: indexPath ?? IndexPath(row: 0, section: 0))
    }

    // MARK: - getStatusDate
    private func getStatusDate(with item: Order.OrderItem) -> String? {
        var dateString: String?
        dateString = item.date
        var dayOrdinal = ""
        if let dateString = dateString,
            let date = VFGDateHelper.getDateFromString(dateString: dateString) {
            let ordinalFormatter = NumberFormatter()
            ordinalFormatter.numberStyle = .ordinal
            let day = Calendar.current.component(.day, from: date)
            dayOrdinal = ordinalFormatter.string(from: NSNumber(value: day)) ?? ""
        }
        return VFGDateHelper.changeDateStringFormat(
            dateString: dateString ?? "",
            format: "E. '\(dayOrdinal)' MMMM",
            dateFormatString: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }

    // MARK: - Actions
    @IBAction func editButtonDidPressed(_ sender: VFGButton) {
        delegate?.editButtonDidPressed(currentIndexPath: indexPath ?? IndexPath(row: 0, section: 0))
    }
}
