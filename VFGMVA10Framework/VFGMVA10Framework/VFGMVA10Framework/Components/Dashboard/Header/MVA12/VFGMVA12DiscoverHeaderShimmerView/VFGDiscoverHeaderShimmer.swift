//
//  VFGDiscoverHeaderShimmer.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 23/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGDiscoverHeaderShimmer: UICollectionReusableView {
    @IBOutlet var shimmerViews: [VFGShimmerView]!

    func startShimmer() {
        shimmerViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }
}
