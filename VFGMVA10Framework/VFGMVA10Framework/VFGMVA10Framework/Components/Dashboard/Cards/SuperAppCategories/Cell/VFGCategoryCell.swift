//
//  VFGCategoryCell.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 22/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// **VFGCategoryCell** is a collection view cell used in *VFGCategoriesView*.
class VFGCategoryCell: UICollectionViewCell {
    /// An image view that presents a category item image.
    @IBOutlet weak var iconImageView: VFGImageView!
    /// A label that presents a category item title.
    @IBOutlet weak var titleLabel: VFGLabel!

    /// Configures *VFGCategoryCell* with the given model.
    /// - Parameters:
    ///   - model: A *VFGCategoryModel* is a model for a category item.
    ///   - isSeeAllCell: A *Bool* value to determine if this cell is a **See All** cell.
    func configure(with model: VFGCategoryModel, isSeeAllCell: Bool = false) {
        var iconImage: UIImage?
        iconImage = VFGImage(named: model.image ?? "")
        iconImageView.image = iconImage
        titleLabel.text = model.title
        backgroundColor = isSeeAllCell ? .VFGWhiteBackground : .VFGDarkGreyBackground
        layer.borderWidth = isSeeAllCell ? 1 : 0
        layer.borderColor = isSeeAllCell ? UIColor.VFGGreyDividerFour.cgColor : UIColor.clear.cgColor
    }
}
