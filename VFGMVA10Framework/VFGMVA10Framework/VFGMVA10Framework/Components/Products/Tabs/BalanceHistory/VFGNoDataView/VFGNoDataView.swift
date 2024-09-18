//
//  VFGNoDataView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 11/22/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGNoDataView: UIView {
    @IBOutlet weak var noBalanceTitleLabel: VFGLabel!
    @IBOutlet weak var noBalanceDescriptionLabel: VFGLabel!

    func configure(title: String, description: String) {
        noBalanceTitleLabel.text = title
        noBalanceDescriptionLabel.text = description
        setupAccessibilityLabels(with: title, and: description)
    }

    func setupAccessibilityLabels(with title: String, and description: String) {
        noBalanceTitleLabel.accessibilityLabel = title
        noBalanceDescriptionLabel.accessibilityLabel = description
    }
}
