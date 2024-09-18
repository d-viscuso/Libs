//
//  VFGAutoBillShimmerView.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 2/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Shimmer view for *VFGAutoBillView*
class VFGAutoBillShimmerView: UIView {
    @IBOutlet var shimmerView: UIView!
    @IBOutlet var allShimmerViews: [VFGShimmerView]!
    @IBOutlet weak var dateCircleView: VFGShimmerView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        startShimmer()
        if UIScreen.main.bounds.height == Constants.iPhone5ScreenHeight {
            dateCircleView.isHidden = true
        }
    }
    /// *VFGAutoBillShimmerView* UI configuration
    func xibSetup() {
        shimmerView = loadViewFromNib(nibName: "VFGAutoBillShimmerView")
        xibSetup(contentView: shimmerView)
    }
    /// Start shimmering
    func startShimmer(completion: (() -> Void)? = nil) {
        allShimmerViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
        completion?()
    }
    /// Stop shimmering
    func stopShimmer() {
        removeFromSuperview()
    }
}
