//
//  PrimaryPlanDescriptionCell.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 02/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class PrimaryPlanDescriptionCell: UITableViewCell {
    @IBOutlet weak var planTitleLabel: VFGLabel!

    func configure(with viewModel: PrimaryPlanCellViewModel?) {
        planTitleLabel?.text = viewModel?.planTitle
    }
}
