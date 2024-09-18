//
//  VFGDeviceSpecificationViewCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 23/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGDeviceSpecificationViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subTitleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    private var accessibilityTextArr: [String] = []

    func updateUI(specification: ChooseDeviceModel.Device.Specifications.QuickSpec?) {
        titleLabel.text = specification?.title
        subTitleLabel.text = specification?.subtitle
        descriptionLabel.text = specification?.details
        accessibilityTextArr = [
            titleLabel.text ?? "",
            "is,",
            subTitleLabel.text ?? "",
            ",",
            descriptionLabel.text ?? ""
        ]
        setupAccessibilityLabel()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

    private func setupAccessibilityLabel() {
        [titleLabel, subTitleLabel, descriptionLabel]
            .forEach { $0?.isAccessibilityElement = false }
        isAccessibilityElement = true
        accessibilityLabel = accessibilityTextArr.joined(separator: " ")
    }
}
