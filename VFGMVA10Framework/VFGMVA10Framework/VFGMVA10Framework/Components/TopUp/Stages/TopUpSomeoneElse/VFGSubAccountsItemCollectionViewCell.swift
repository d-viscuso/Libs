//
//  VFGSubAccountsItemCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Zaki on 10/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGSubAccountsItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: VFGLabel?
    @IBOutlet weak var subtitleLabel: VFGLabel?
    @IBOutlet weak var imageView: VFGImageView?

    func setup(title: String, msisdn: String, imageName: String) {
        titleLabel?.text = title.localized(bundle: .mva10Framework)
        subtitleLabel?.text = msisdn.localized(bundle: .mva10Framework)
        imageView?.image = VFGImage(named: imageName)
    }
}
