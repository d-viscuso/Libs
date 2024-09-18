//
//  AddCardShimmerView.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 9/14/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class AddCardShimmerView: UIView {
    @IBOutlet var shimmerdViews: [VFGShimmerView]!
    @IBOutlet var view: UIView!
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
        view = loadViewFromNib(nibName: "AddCardShimmerView")
        xibSetup(contentView: view)
    }

    func startShimmer() {
        shimmerdViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }
    func stopShimmer() {
        removeFromSuperview()
    }
}
