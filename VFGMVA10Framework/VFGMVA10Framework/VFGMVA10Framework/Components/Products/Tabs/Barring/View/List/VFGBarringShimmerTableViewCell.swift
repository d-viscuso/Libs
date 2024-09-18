//
//  VFGBarringShimmerTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 17/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Barring shimmer cell.
class VFGBarringShimmerTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet var shimmerdViews: [VFGShimmerView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    func startShimmer() {
        for view in shimmerdViews {
            view.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }
}
