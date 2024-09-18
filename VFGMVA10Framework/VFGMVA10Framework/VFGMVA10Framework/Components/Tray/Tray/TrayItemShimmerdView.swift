//
//  TrayItemShimmerdView.swift
//  VFGMVA10Framework
//
//  Created by Essam Orabi on 08/11/2021.
//

import VFGMVA10Foundation

class TrayItemShimmerdView: UIView {
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

    func xibSetup() {
        guard let view = loadViewFromNib(nibName: "TrayItemShimmerdView") else {
            VFGErrorLog("TrayItemShimmerdView is nil")
            return
        }
        xibSetup(contentView: view)
    }
    func startShimmer() {
        shimmerdViews.forEach { shimmerdView in
            shimmerdView.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }
}
