//
//  VFGBreakdownViewCell.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGBreakdownViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var headerStackView: VFGProductHeaderStackView!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var detailsStackViewHeightConstraint: NSLayoutConstraint!

    let detailsItemHeight: CGFloat = 25.0

    override func prepareForReuse() {
        super.prepareForReuse()

        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        detailsStackViewHeightConstraint.constant = 0
    }

    func setup(
        title: String,
        productHeader: VFGProductHeaderUIModel,
        productItems: [VFGProductItemUIModel]
    ) {
        titleLabel.text = title
        headerStackView.setup(productHeader: productHeader)

        productItems.forEach { item in
            let itemStackView = VFGProductItemStackView()
            itemStackView.setup(productItem: item)
            self.detailsStackView.addArrangedSubview(itemStackView)
            detailsStackViewHeightConstraint.constant += detailsItemHeight
        }
        setupAccessibilityLabel()
    }
}

extension VFGBreakdownViewCell {
    func setupAccessibilityLabel() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        titleLabel.accessibilityIdentifier = "UDCostBreakdownTitleID"
    }
}
