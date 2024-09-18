//
//  VFGCategoryShimmerCollectionCell.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 09/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGCategoryShimmerCollectionCell: UICollectionViewCell {
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
