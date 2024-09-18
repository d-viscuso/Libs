//
//  VFGProductItemStackView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGProductItemStackView: UIStackView {
    @IBOutlet weak var nameLabel: VFGLabel!
    @IBOutlet weak var priceLabel: VFGLabel!

    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        guard let contentView = self.loadViewFromNib(nibName: className, in: .mva10Framework) else {
            return
        }

        xibSetup(contentView: contentView)
    }

    func setup(productItem: VFGProductItemUIModel, accessibilityID: Int = 0) {
        nameLabel.text = productItem.name.text
        nameLabel.font = productItem.name.font

        priceLabel.text = productItem.price.text + (productItem.currency ?? "")
        priceLabel.font = productItem.price.font
        setupAccessibilityLabel()
        setupAccessibilityIDs(accessibilityID: accessibilityID)
    }
}

extension VFGProductItemStackView {
    func setupAccessibilityLabel() {
        nameLabel.accessibilityLabel = nameLabel.text ?? ""
        priceLabel.accessibilityLabel = priceLabel.text ?? ""
    }

    func setupAccessibilityIDs(accessibilityID: Int) {
        nameLabel.accessibilityIdentifier = "UDCostSummaryFooterRowLabel\(accessibilityID)"
        priceLabel.accessibilityIdentifier = "UDCostSummaryFooterRowPrice\(accessibilityID)"
    }
}

struct VFGProductItemUIModel {
    let name: (text: String, font: UIFont)
    let price: (text: String, font: UIFont)
    let currency: String?
}
