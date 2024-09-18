//
//  OrderSummaryQuickActionHeader.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 16/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Quick action header for order summary
class OrderSummaryQuickActionHeader: UIView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "my_orders_action_order_summary".localized(bundle: .mva10Framework)
        subtitleLabel.text = "my_orders_order_number".localized(bundle: .mva10Framework)
    }
}
