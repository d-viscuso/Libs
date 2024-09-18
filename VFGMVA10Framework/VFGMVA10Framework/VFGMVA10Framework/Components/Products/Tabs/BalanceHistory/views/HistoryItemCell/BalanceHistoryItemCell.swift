//
//  BalanceHistoryItemCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class BalanceHistoryItemCell: UITableViewCell {
    @IBOutlet weak var balanceIconImageView: VFGImageView!
    @IBOutlet weak var balanceTitleLabel: VFGLabel!
    @IBOutlet weak var balanceSubtitleLabel: VFGLabel!
    @IBOutlet weak var balanceAmountLabel: VFGLabel!
    @IBOutlet weak var balanceAmountInfoLabel: VFGLabel!
    @IBOutlet weak var balancedescription: VFGLabel!

    func configure(with viewModel: BalanceHistoryItemViewModel?) {
        balanceIconImageView.image = VFGImage(named: viewModel?.iconName ?? "")
        balanceTitleLabel.text = viewModel?.title
        balancedescription.text = viewModel?.balanceDescription
        balanceSubtitleLabel.text = viewModel?.subtitle
        balanceAmountLabel.text = viewModel?.amount
        if let amountColor = viewModel?.amountColor {
            balanceAmountLabel.textColor = amountColor
        }
        balanceAmountInfoLabel.text = viewModel?.amountInfo
        setupAccessibilityLabels()
    }

    func setupAccessibilityLabels() {
        balanceTitleLabel.accessibilityLabel = balanceTitleLabel.text ?? ""
        balanceSubtitleLabel.accessibilityLabel = balanceSubtitleLabel.text ?? ""
        balanceAmountLabel.accessibilityLabel = balanceAmountLabel.text ?? ""
        balanceAmountInfoLabel.accessibilityLabel = balanceAmountInfoLabel.text ?? ""
        balancedescription.accessibilityLabel = balancedescription.text ?? ""
    }
}
