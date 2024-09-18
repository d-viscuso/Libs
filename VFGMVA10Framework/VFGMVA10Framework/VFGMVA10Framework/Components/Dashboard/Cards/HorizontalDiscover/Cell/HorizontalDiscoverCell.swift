//
//  HorizontalDiscoverCell.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 14/08/2022.
//

import UIKit
import VFGMVA10Foundation

/// Dashboard horizontal discover collection view edit card
class HorizontalDiscoverCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var cardView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
    /// *HorizontalDiscoverCell* configuration
    public func configure(with itemModel: HorizontalDiscoverItemModel?) {
        guard let model = itemModel else {
            return
        }
        titleLabel.text = model.title?.localized(bundle: .mva10Framework)
        iconImageView.download(by: model.icon ?? "", placeholder: VFGImage(named: model.placeHolderIcon))
    }
}

extension HorizontalDiscoverCell {
    func addShadow() {
        cardView.roundCorners()
        cardView.dropShadow(
            color: UIColor.VFGVeryLightGreyDarkBackground,
            alpha: 0.16,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)
    }
}
