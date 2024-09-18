//
//  VFGTrayViewController+ShimmerdView.swift
//  VFGMVA10Framework
//
//  Created by Essam Orabi on 11/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension VFGTrayViewController {
    func loadShimmerdView() {
        tobiShimmerView.isHidden = false
        tobiShimmerView.startAnimation()
        leftShimmerView.frame = leftItemsStackView?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        leftItemsStackView?.addSubview(leftShimmerView)
        leftShimmerView.layoutSubviews()
        rightShimmerView.frame = rightItemsStackView?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        rightItemsStackView?.addSubview(rightShimmerView)
        rightShimmerView.layoutSubviews()
    }

    func removeShimmerdView() {
        leftShimmerView.stopShimmer()
        rightShimmerView.stopShimmer()
        tobiShimmerView.isHidden = true
    }

    func setLabelNumOfLines(label: VFGLabel, numberOfLines: Int) {
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = numberOfLines
    }

    func setAccessibilityIdentifier(trayItem: TrayItemView, identifier: String) {
        trayItem.button.accessibilityIdentifier = "trayItem\(identifier)"
        trayItem.itemTitleLabel.accessibilityIdentifier = "trayItemTitle\(identifier)"
        trayItem.iconImageView.accessibilityIdentifier = "trayItemIcon\(identifier)"
    }
}
