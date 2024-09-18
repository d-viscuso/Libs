//
//  VFGroupedItemsShimmerView.swift
//  VFGMVA10Framework
//
//  Created by Essam Orabi on 20/02/2023.
//

import VFGMVA10Foundation

class VFGroupedItemsShimmerView: UIView {
    @IBOutlet var shimmerViews: [VFGShimmerView]!
    public init() {
        super.init(frame: CGRect.zero)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    /// Grouped items shimmer view XIB load
    func xibSetup() {
        guard let view = loadViewFromNib(nibName: "VFGroupedItemsShimmerView") else {
            return
        }
        xibSetup(contentView: view)
    }
    /// Start Grouped items shimmering process
    func startShimmer() {
        shimmerViews.forEach { shimmerdView in
            shimmerdView.startAnimation()
        }
    }
}
