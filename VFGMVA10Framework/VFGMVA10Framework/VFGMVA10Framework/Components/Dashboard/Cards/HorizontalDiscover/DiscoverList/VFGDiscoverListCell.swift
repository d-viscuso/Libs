//
//  VFGDiscoverListCell.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 18/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGDiscoverListCell: UICollectionViewCell {
    static let heightToWidthRatio: CGFloat = 1.15
    private let imageViewHeightRatio: CGFloat = 0.85

    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var productImageView: VFGImageView!
    @IBOutlet weak var productImageViewHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        productImageViewHeight.constant = productImageView.frame.width * imageViewHeightRatio
    }

    func setupWith(_ model: HorizontalDiscoverItemModel) {
        titleLabel.text = model.title
        productImageView.image = VFGImage(named: model.icon)
        if let badgeCount = model.badge, badgeCount > 0 {
            badgeView.isHidden = false
            badgeLabel.text = "\(badgeCount)"
        } else {
            badgeView.isHidden = true
        }
    }
}
