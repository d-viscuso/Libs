//
//  VFGSubTrayShimmerCell.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 2/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// *VFGSubTray* collection view shimmer cell
class VFGSubTrayShimmerCell: UICollectionViewCell {
    @IBOutlet var shimmerViews: [VFGShimmerView]!
    /// Start cell shimmering process
    /// - Parameters:
    ///    - completion: A clusure to handle more actions after starting shimmer
    func startShimmer(completion: (() -> Void)? = nil) {
        shimmerViews.forEach { shimmerView in
            shimmerView.startAnimation()
        }
        completion?()
    }
    /// End cell shimmering process
    func stopShimmer() {
        removeFromSuperview()
    }
}
