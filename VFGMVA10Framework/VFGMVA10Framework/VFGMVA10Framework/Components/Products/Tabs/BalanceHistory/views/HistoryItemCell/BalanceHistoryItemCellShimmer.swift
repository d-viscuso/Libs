//
//  BalanceHistoryItemCellShimmer.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 18/11/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class BalanceHistoryItemCellShimmer: UITableViewCell {
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
