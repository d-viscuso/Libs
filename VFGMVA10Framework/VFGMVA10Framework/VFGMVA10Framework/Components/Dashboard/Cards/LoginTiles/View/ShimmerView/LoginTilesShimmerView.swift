//
//  LoginTilesShimmerView.swift
//  VFGMVA10Framework
//
//  Created by Sarah Gamal on 26/04/2023.
//

import UIKit
import VFGMVA10Foundation

class LoginTilesShimmerView: UIView {
    @IBOutlet var shimmerView: UIView!
    @IBOutlet var shimmerViews: [VFGShimmerView]!
    @IBOutlet var shimmerContainerViews: [UIView]!
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
    }

    func xibSetup() {
        shimmerView = loadViewFromNib(nibName: String(describing: LoginTilesShimmerView.self))
        xibSetup(contentView: shimmerView)
    }

    /// Start shimmering
    func startShimmer(completion: (() -> Void)? = nil) {
        shimmerContainerViews.forEach { view in
            view.configureShadow()
        }
        shimmerViews.forEach { shimmeredView in
            shimmeredView.theme = .mva12
            shimmeredView.startAnimation()
        }
        completion?()
    }

    /// Stop shimmering
    func stopShimmer() {
        removeFromSuperview()
    }
}
