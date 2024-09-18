//
//  BalanceAndProductShimmerCell.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 1/20/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard usage card shimmer view
public class UsageShimmerdCard: UIView {
    @IBOutlet var shimmerdViews: [VFGShimmerView]!

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
        guard let view = loadViewFromNib(nibName: "UsageShimmerdCard") else {
            VFGErrorLog("UsageShimmerdCard is nil")
            return
        }
        xibSetup(contentView: view)
    }
    /// Shimmer view start shimmering
    func startShimmer() {
        shimmerdViews.forEach { shimmerdView in
            shimmerdView.startAnimation()
        }
    }
}
