//
//  MoreCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 17/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGMoreCardItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var badgeLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var itemImageView: VFGImageView!

    func configure(with item: VFGMoreItemModel?) {
        guard let item = item else { return }
        badgeLabel.text = String(item.badge ?? 0)
        titleLabel.text = item.title
        itemImageView.download(by: item.icon ?? "")
    }
}
