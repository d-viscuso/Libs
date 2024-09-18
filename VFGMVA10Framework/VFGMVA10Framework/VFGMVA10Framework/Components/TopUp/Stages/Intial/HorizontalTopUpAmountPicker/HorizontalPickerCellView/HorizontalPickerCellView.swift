//
//  HorizontalPickerCellView.swift
//  VFGMVA10Framework
//
//  Created by Burak Çokyıldırım on 4.09.2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class HorizontalPickerCellView: UIView {
    @IBOutlet private weak var titleLabel: VFGLabel!
    @IBOutlet private weak var giftImageView: VFGImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        giftImageView.accessibilityIdentifier = "TPmainGiftIcon"
    }

    func configure(with model: AmountPickerCellViewModel) {
        switch model.currencyPosition {
        case .left:
            titleLabel.text = "\(model.currencyText)\(model.amountText)"
        case .right:
            titleLabel.text = "\(model.amountText)\(model.currencyText)"
        }

        guard model.hasGift else {
            giftImageView.isHidden = true
            return
        }

        giftImageView.image = VFGImage(named: model.giftIconImageName)
        giftImageView.isHidden = false
    }
}
