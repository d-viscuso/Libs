//
//  AddOnsProductShimmerCell.swift
//  VFGMVA10Framework
//
//  Created by Moamen Abd Elgawad on 14/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class AddOnsProductShimmerCell: UICollectionViewCell {
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
