//
//  VFGSelectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 20/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGSelectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subTitleLabel: VFGLabel!

    func setup(_ model: VFGSelectionUIModel) {
        var isSelected: Bool {
            model.isSelected
        }

        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
        titleLabel.font = isSelected ? .vodafoneBold(18.7) : .vodafoneRegular(18)
        subTitleLabel.font = UIFont.vodafoneRegular(14.6)
        containerView.layer.borderWidth = isSelected ? 2.1 : 1
        containerView.layer.borderColor = isSelected ?
            UIColor.VFGSelectedInputOutline.cgColor : UIColor.VFGDefaultSelectionOutline.cgColor
        setupAccessibilityLabels()
    }

    private func setupAccessibilityLabels() {
        isAccessibilityElement = false
        titleLabel.isAccessibilityElement = true
        subTitleLabel.isAccessibilityElement = true
        subTitleLabel.accessibilityLabel = (subTitleLabel.text ?? "").replacingOccurrences(of: "/", with: "per")
    }
}

struct VFGSelectionUIModel {
    let title: String?, subTitle: String?, selectedText: String?
    let borderColor: CGColor
    let isSelected: Bool
}
