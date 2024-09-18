//
//  VFGBreakdownFooterView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGBreakdownFooterView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var detailsStackViewHeightConstraint: NSLayoutConstraint!

    let detailsItemHeight: CGFloat = 25.0

    func setup(
        title: String,
        productItems: [VFGProductItemUIModel]
    ) {
        titleLabel.text = title
        titleLabel.font = .vodafoneBold(17)

        for index in 0..<productItems.count {
            let itemStackView = VFGProductItemStackView()
            itemStackView.setup(productItem: productItems[index], accessibilityID: index)
            self.detailsStackView.addArrangedSubview(itemStackView)
            detailsStackViewHeightConstraint.constant += detailsItemHeight
        }
        setupAccessibilityLabel()
        setupAccessibilityID()
    }
}

extension VFGBreakdownFooterView {
    func setupAccessibilityLabel() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
    }

    func setupAccessibilityID() {
        titleLabel.accessibilityIdentifier = "UDCostSummaryFooterTitle"
    }
}
