//
//  BalanceHistorySectionHeaderShimmer.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 19/11/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
class BalanceHistorySectionHeaderShimmer: UIView {
    @IBOutlet var shimmerdView: VFGShimmerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        shimmerdView.startAnimation()
    }
}
