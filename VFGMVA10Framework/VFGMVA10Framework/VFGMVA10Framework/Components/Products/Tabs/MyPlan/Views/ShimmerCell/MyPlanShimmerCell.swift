//
//  MyPlanShimmerCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 10/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class MyPlanShimmerCell: UITableViewCell {
    // Outlets
    @IBOutlet var shimmerViews: [VFGShimmerView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }

    func startShimmer() {
        shimmerViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }

    func addShadow() {
        contentView.layer.cornerRadius = 6.2
        contentView.addingShadow(size: CGSize(width: 0, height: 1), radius: 4, opacity: 0.16)
        contentView.layer.masksToBounds = true
    }
}
