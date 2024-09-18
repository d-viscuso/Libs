//
//  PaymentCardShimmerCell.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 9/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class PaymentCardShimmerCell: UITableViewCell {
    @IBOutlet var shimmerdViews: [VFGShimmerView]!
    func startShimmer() {
        shimmerdViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }
    func stopShimmer() {
        removeFromSuperview()
    }
}
