//
//  VFGDeviceCollectionAndDeliveryCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 22/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGCollectionAndDeliverySelectionCell: UICollectionViewCell {
    @IBOutlet weak var logoImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var timeLabel: VFGLabel!
    @IBOutlet weak var priceLabel: VFGLabel!
    private var accessibilityTextArr: [String] = []

    func setupUI(collectionAndDelivery: VFGDeviceModel.CollectionAndDelivery) {
        titleLabel.text = collectionAndDelivery.title
        timeLabel.text = collectionAndDelivery.duration
        priceLabel.text = collectionAndDelivery.formattedPrice
        logoImageView.image = UIImage(named: collectionAndDelivery.imageUrl ?? "", in: .mva10Framework)
        accessibilityTextArr = [
            titleLabel.text ?? "",
            ", takes",
            timeLabel.text ?? "",
            ", and costs",
            priceLabel.text ?? ""
        ]
        setupAccessibilityLabels()
    }

    private func setupAccessibilityLabels() {
        [logoImageView, titleLabel, timeLabel, priceLabel]
            .forEach { $0?.isAccessibilityElement = false }
        isAccessibilityElement = true
        accessibilityLabel = accessibilityTextArr
            .joined(separator: " ")
            .replacingOccurrences(of: "-", with: "to")
    }
}
