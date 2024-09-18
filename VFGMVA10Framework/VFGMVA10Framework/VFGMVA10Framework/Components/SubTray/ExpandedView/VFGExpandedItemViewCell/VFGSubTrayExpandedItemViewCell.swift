//
//  VFGSubTrayExpandedItemViewCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 06/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
/// Sub tray expanded view collection view cell
class VFGSubTrayExpandedItemViewCell: UICollectionViewCell {
    @IBOutlet weak var itemContainerView: VFGSubTrayExpandedItemView!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint?
    /// Update layer for *VFGSubTrayExpandedItemViewCell* selected cell
    func updateOutlineSelected() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.VFGActiveSelectionOutline.cgColor
    }
    /// Update layer for *VFGSubTrayExpandedItemViewCell* unselected cell
    func updateOutlineUnselected() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.VFGDefaultSelectionOutline.cgColor
    }
    /// Update *VFGSubTrayExpandedItemViewCell* trailing constraint constant
    /// - Parameters:
    ///    - value: Cell new trailing constraint constant
    func updateContainerTrailingContraint(with value: CGFloat) {
        containerTrailingConstraint?.constant = value
        layoutIfNeeded()
    }
}
