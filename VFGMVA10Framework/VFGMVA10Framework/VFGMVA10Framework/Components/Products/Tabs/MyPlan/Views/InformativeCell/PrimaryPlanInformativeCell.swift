//
//  PrimaryPlanInformativeCell.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 02/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class PrimaryPlanInformativeCell: UITableViewCell {
    @IBOutlet weak var planIconImageView: VFGImageView!
    @IBOutlet weak var planTitleLabel: VFGLabel!

    func configure(with viewModel: PrimaryPlanCellViewModel?, isTextBold: Bool? = false) {
        planTitleLabel?.text = viewModel?.planTitle
        if isTextBold ?? false {
            planTitleLabel.font = UIFont.vodafoneBold(16)
        }

        guard let planIcon = viewModel?.planIcon, !planIcon.isEmpty else {
            planIconImageView?.removeFromSuperview()
            return
        }

        planIconImageView?.image = VFGImage(named: planIcon)
        planIconImageView.backgroundColor = viewModel?
            .hasBackgroundColor ?? false ?
            .VFGSecondaryButtonActiveRedBG : .clear
    }
}
