//
//  VFGAddPaymentMethodCell.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 9/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

/// VFGAddPaymentMethodCell is a cell that represents the add payment method card
public class VFGAddPaymentMethodCell: UICollectionViewCell {
    @IBOutlet weak var addNewPaymentLabel: VFGLabel!

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                layer.borderColor = UIColor.VFGRedOrangeBorder.cgColor
            }
        }
    }

    /// configure VFGAddPaymentMethodCell
    /// - Parameter labelText: Is the text that appears at the middle of the cell
    public func config(labelText: String) {
        addNewPaymentLabel.text = labelText
        addNewPaymentLabel.accessibilityLabel = "Add new card"
    }
}
