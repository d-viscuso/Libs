//
//  VFGMoreListCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 26/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGMoreListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var itemImageView: VFGImageView!
    @IBOutlet weak var dividerView: UIView!

    func configure(with item: VFGMoreItemModel?) {
        guard let item = item else { return }
        titleLabel.text = item.title
        itemImageView.download(by: item.icon ?? "")
    }
}
