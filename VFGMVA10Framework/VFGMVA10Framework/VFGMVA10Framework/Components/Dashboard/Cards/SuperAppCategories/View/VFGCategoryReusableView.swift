//
//  VFGCategoryReusableView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 26/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGCategoryReusableView: UICollectionReusableView {
    @IBOutlet weak var categoryTitleLabel: VFGLabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        categoryTitleLabel.text = nil
    }
}
