//
//  ProductSwitcherShimmerCell.swift
//  VFGMVA10Framework
//
//  Created by Essam Orabi on 12/02/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class ProductSwitcherShimmerCell: UICollectionViewCell {
    @IBOutlet var shimmerdViews: [VFGShimmerView]!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.roundCorners(cornerRadius: 6)
    }
    func startShimmer() {
        shimmerdViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }
    func stopShimmer() {
        removeFromSuperview()
    }
}
