//
//  PastOrderItemView.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 17/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// *PastOrderCell* item view
class PastOrderItemView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var itemTitleLabel: VFGLabel!
    @IBOutlet weak var iteamImage: VFGImageView!
    @IBOutlet weak var statusTitleLabel: VFGLabel!
    @IBOutlet weak var statusLabel: VFGLabel!
    @IBOutlet weak var dateCompleted: VFGLabel!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var lowerStack: UIStackView!
    @IBOutlet weak var lowerStackHeight: NSLayoutConstraint!
    @IBOutlet weak var upperStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowerStackBottomConstraint: NSLayoutConstraint!

    let stackBottomConstraintDefaultValue: CGFloat = 16
    let lastUpperStackBottomConstraintValue: CGFloat = 32
    let separatorHeightValue: CGFloat = 1

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAccessibility()
    }

    private func setupAccessibility() {
        itemTitleLabel.isAccessibilityElement = true
        iteamImage.isAccessibilityElement = true
        statusTitleLabel.isAccessibilityElement = true
        statusLabel.isAccessibilityElement = true
        dateCompleted.isAccessibilityElement = true
    }

    // MARK: - setup view
    /// *PastOrderItemView* configuration
    /// - Parameters:
    ///    - item: Order item data
    func setup(with item: Order.OrderItem) {
        itemTitleLabel.text = item.title
        iteamImage.image = VFGImage(named: item.image)
        statusTitleLabel.text = "my_orders_status".localized(bundle: .mva10Framework)
        statusLabel.text = item.status
        iteamImage.accessibilityValue = item.imageAccessibilityDescription
        if item.status == OrderState.completed.rawValue {
            dateCompleted.isHidden = false
            let dateString = VFGDateHelper.changeDateStringFormat(
                dateString: item.dateCompleted ?? "",
                format: "dd MMMM yyyy",
                dateFormatString: Constants.AddOnsTimeline.dateFormat,
                locale: Constants.AddOnsTimeline.localeUS)
            dateCompleted.text = String(
                format: "my_orders_date_completed".localized(bundle: .mva10Framework),
                dateString ?? "")
        } else {
            dateCompleted.isHidden = true
            lowerStackHeight.constant = separatorHeightValue
        }
    }

    // MARK: - Hide Bottom Separator View
    /// Responsible for hidding botton separator
    func hideBottomSeparator() {
        bottomSeparatorView.isHidden = true
        if dateCompleted.isHidden {
            lowerStackHeight.constant = 0
            upperStackBottomConstraint.constant = lastUpperStackBottomConstraintValue
        } else {
            lowerStackBottomConstraint.constant = stackBottomConstraintDefaultValue
        }
    }
}
