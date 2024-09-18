//
//  ScrollableCardItemShimmerCollectionCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 16/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class ScrollableCardItemShimmerCollectionCell: UICollectionViewCell {
    @IBOutlet var shimmerViews: [VFGShimmerView]!

    func startShimmer() {
        shimmerViews?.forEach { shimmeredView in
            shimmeredView.theme = .mva12
            shimmeredView.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }
}
