//
//  VFGAppointmentServiceShimmerCollectionCell.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGAppointmentServiceShimmerCell: UICollectionViewCell {
    @IBOutlet var shimmerViews: [VFGShimmerView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureShadow()
    }

    func startShimmer() {
        shimmerViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }
}
