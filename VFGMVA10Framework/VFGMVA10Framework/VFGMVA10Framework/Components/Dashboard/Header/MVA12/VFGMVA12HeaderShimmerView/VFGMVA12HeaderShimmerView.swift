//
//  VFGMVA12HeaderShimmerView.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 8/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGMVA10Foundation

class VFGMVA12HeaderShimmerView: UIView {
    @IBOutlet var shimmerViews: [VFGShimmerView]!

    override func layoutSubviews() {
        super.layoutSubviews()
        startShimmer()
    }

    func startShimmer() {
        shimmerViews.forEach { shimmeredView in
            shimmeredView.theme = .mva12
            shimmeredView.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }
}
