//
//  ProductSwitcherDetailedUsageView.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 9/2/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class ProductSwitcherDetailedUsageView: UIView {
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descLabel: VFGLabel!
    @IBOutlet weak var remainingRatioProgressBar: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        remainingRatioProgressBar.layer.masksToBounds = true
        remainingRatioProgressBar.layer.cornerRadius = 3
    }

    func setContentItem(_ contentItem: ProductSwitcherContentItem, for width: CGFloat) {
        iconImageView.image = contentItem.icon
        titleLabel.text = contentItem.title
        descLabel.text = contentItem.desc

        guard let progressRatio = contentItem.progressRatio else { return }
        let ratioPercentage = round(progressRatio * 100)
        let grayColorPercent = 100.0 - (ratioPercentage + 1.0)
        let percentages = [ratioPercentage, 1.0, grayColorPercent]
        let colors: [UIColor] = [.VFGRedProgressBar, .white, .VFGAluminiumProgressBar]
        remainingRatioProgressBar.frame.size.width = width
        remainingRatioProgressBar.fillProgressBarColors(colors, withPercentage: percentages)
    }
}
