//
//  VFGCategoryListCell.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 20/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation


class VFGCategoryListCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var categoryImageView: VFGImageView!

    func configure(with model: VFGCategoryModel) {
        titleLabel.text = model.title
        categoryImageView.image = VFGImage(named: model.image)
    }
}
