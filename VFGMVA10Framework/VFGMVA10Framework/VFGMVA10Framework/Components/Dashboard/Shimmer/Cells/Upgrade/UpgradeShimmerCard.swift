//
//  UpgradeShimmerCard.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 2/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard upgrade card shimmer view
public class UpgradeShimmerCard: UIView {
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
    /// Dashboard upgrade card shimmer view XIB load
    func xibSetup() {
        guard let view = loadViewFromNib(nibName: "UpgradeShimmerCard") else {
            VFGErrorLog("UpgradeShimmerCard is nil")
            return
        }
        xibSetup(contentView: view)
    }
    /// Start dashboard upgrade card shimmering process
    func startShimmer() {
        shimmerdViews.forEach { shimmerdView in
            shimmerdView.startAnimation()
        }
    }
}
