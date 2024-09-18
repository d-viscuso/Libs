//
//  TopUpShimmerView.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 1/12/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class TopUpShimmerView: UIView {
    @IBOutlet var shimmeredViews: [VFGShimmerView]!
    @IBOutlet var view: UIView!
    @IBOutlet weak var verticalPickerShimmerView: UIView!
    @IBOutlet weak var horizontalPickerShimmerView: UIView!
    @IBOutlet weak var tabsShimmerView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    convenience init(
        withCustomAmount: Bool,
        amountPickerAxis: TopupAmountPickerAxis,
        frame: CGRect
    ) {
        self.init(frame: frame)
        xibSetup()
        verticalPickerShimmerView.isHidden = withCustomAmount
        horizontalPickerShimmerView.isHidden = withCustomAmount
        tabsShimmerView.isHidden = !withCustomAmount

        switch amountPickerAxis {
        case .vertical where !withCustomAmount:
            horizontalPickerShimmerView.isHidden = true
        case .horizontal where !withCustomAmount:
            verticalPickerShimmerView.isHidden = true
        default:
            break
        }
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        startShimmer()
    }

    func xibSetup() {
        view = loadViewFromNib(nibName: "TopUpShimmerView")
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
