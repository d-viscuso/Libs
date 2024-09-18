//
//  PlanExtraInfoItemView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class PlanExtraInfoItemView: StackItemView<PlanExtraInfo> {
    @IBOutlet weak var infoTitleLabel: VFGLabel!
    @IBOutlet weak var planInfoLabel: VFGLabel!
    @IBOutlet weak var separator: UIView!

    override func setupView(with itemVM: PlanExtraInfo) {
        super.setupView(with: itemVM)

        infoTitleLabel?.text = itemVM.infoTitle
        planInfoLabel?.text = itemVM.infoDetails
        infoTitleLabel.textColor = .primaryTextColor
        planInfoLabel.textColor = .primaryTextColor
        separator.backgroundColor = .firstDivider
    }

    func hideSeparator() {
        separator.isHidden = true
    }
}
