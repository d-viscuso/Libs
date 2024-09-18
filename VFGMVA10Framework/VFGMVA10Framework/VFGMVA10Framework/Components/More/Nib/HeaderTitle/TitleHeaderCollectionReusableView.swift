//
//  TitleHeaderCollectionReusableView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 26/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: VFGLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "quick_links_title".localized(bundle: .mva10Framework)
    }
}
