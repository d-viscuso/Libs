//
//  StoryCircleShimmerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 25/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class StoryCircleShimmerCell: UICollectionViewCell {
    @IBOutlet var shimmmetViews: [VFGShimmerView]!

    func startShimmer(theme: ShimmerTheme) {
        shimmmetViews.forEach { shimmeredView in
            shimmeredView.theme = theme
            shimmeredView.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }
}
