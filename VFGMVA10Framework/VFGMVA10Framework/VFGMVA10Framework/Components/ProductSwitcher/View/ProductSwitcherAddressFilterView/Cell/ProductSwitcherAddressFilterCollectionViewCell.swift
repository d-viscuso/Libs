//
//  ProductSwitcherAddressFilterCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 10/4/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class ProductSwitcherAddressFilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var addressLabel: VFGLabel!

    // MARK: - Static Properties
    static let reuseId = "ProductSwitcherAddressFilterCollectionViewCell"

    func configure(with address: String, isSelected: Bool) {
        addressLabel.text = address
        addressLabel.textColor = isSelected ? UIColor.VFGSelectedText : UIColor.secondaryTextColor
        addressLabel.font = isSelected ? UIFont.vodafoneBold(14) : UIFont.vodafoneRegular(14)
        borderView.layer.borderColor = isSelected ? UIColor.VFGSelectedText?.cgColor : UIColor.VFGGreyBorder.cgColor
        borderView.layer.borderWidth = isSelected ? 2 : 1
    }
}
