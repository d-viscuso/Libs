//
//  VFDashboardViewController+traitCollectionDidChange.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 13/06/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

// MARK: - Update CGColors with TraitCollection
extension VFDashboardViewController {
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                collectionBackgroundView.layer.sublayers?.first?.removeFromSuperlayer()
                if collectionView.traitCollection.userInterfaceStyle == .dark {
                    collectionBackgroundView.setGradientBackgroundColor(colors: UIColor.VFGDashBoardGradient)
                } else {
                    collectionBackgroundView.backgroundColor = .VFGDarkGreyBackground
                }
                updateBackgroundGradientLayerFrame()
                guard let eioStatus = eioModel?.eioStatus else { return }
                updateBackground(eioStatus)
            }
        }
    }
}
