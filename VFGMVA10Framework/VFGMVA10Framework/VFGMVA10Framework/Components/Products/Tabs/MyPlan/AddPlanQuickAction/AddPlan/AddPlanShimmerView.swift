//
//  AddPlanShimmerView.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 28/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class AddPlanShimmerView: UIView {
    @IBOutlet var shimmeredViews: [VFGShimmerView]!
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
        view = loadViewFromNib(nibName: "AddPlanShimmerView")
        xibSetup(contentView: view)
    }

    func startShimmer() {
        shimmeredViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }
    func stopShimmer() {
        removeFromSuperview()
    }
}
