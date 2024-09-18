//
//  VFGLabel+Attributes.swift
//  VFGMVA10
//
//  Created by Mohamed Mahmoud Zaki on 2/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGLabel {
    func prepareBoldLabel() {
        textColor = .boldText
        font = UIFont.vodafoneBold(21)
    }

    func prepareRegularLabel(row: Int) {
        let colorAlpha = 0.5 - (CGFloat(row) * 0.05)
        textColor = UIColor.regularText(alpha: colorAlpha)
        font = UIFont.vodafoneRegular(21)
    }
}
