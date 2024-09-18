//
//  HorizontalDiscoverShimmerCell.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 08/02/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class HorizontalDiscoverShimmerCell: UICollectionViewCell {
    @IBOutlet var shimmerViews: [VFGShimmerView]!

    func startShimmer() {
        shimmerViews.forEach { shimmerView in
            shimmerView.theme = .mva12
            shimmerView.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }
}
