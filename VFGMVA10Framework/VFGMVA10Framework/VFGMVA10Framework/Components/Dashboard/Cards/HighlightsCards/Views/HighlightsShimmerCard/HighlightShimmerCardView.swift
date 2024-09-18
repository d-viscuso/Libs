//
//  HighlightShimmerCardView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 22/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class HighlightShimmerCardView: UIView {
    @IBOutlet var shimmerViews: [VFGShimmerView]!

    public init() {
        super.init(frame: CGRect.zero)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        startShimmer()
    }
    /// Shimmer view file load
    func xibSetup() {
        let view = loadViewFromNib(nibName: "HighlightShimmerCardView") ?? HighlightShimmerCardView()
        xibSetup(contentView: view)
    }

    func startShimmer(completion: (() -> Void)? = nil) {
        shimmerViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
        completion?()
    }
}
