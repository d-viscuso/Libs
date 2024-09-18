//
//  OfferShimmerdCell.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 1/20/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard offer card shimmer view
public class OfferShimmerdCard: UIView {
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
    /// Dashboard offer card shimmer view XIB load
    func xibSetup() {
        guard let view = loadViewFromNib(nibName: "OfferShimmerdCard") else {
            VFGErrorLog("OfferShimmerdCard is nil")
            return
        }
        xibSetup(contentView: view)
    }
    /// Start dashboard offer card shimmering process
    func startShimmer() {
        shimmerdViews.forEach { shimmerdView in
            shimmerdView.startAnimation()
        }
    }
}
