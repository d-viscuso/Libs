//
//  VFGShopViewCell.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 29/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGShopViewCell: UICollectionViewCell {
    private let imageViewHeightRatio: CGFloat = 0.85

    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var imageView: VFGImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewHeight.constant = imageView.frame.width * imageViewHeightRatio
    }

    func setupWith(_ model: VFGShopItemModel) {
        titleLabel.text = model.title
        imageView.download(by: model.image ?? "")
        if let badgeCount = model.badge, badgeCount > 0 {
            badgeView.isHidden = false
            badgeLabel.text = "\(badgeCount)"
        } else {
            badgeView.isHidden = true
        }
    }
}
