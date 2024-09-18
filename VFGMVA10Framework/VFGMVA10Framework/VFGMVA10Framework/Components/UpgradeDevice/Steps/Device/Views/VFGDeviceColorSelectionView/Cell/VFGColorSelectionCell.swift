//
//  VFGColorSelectionCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 19/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGColorSelectionCell: UICollectionViewCell {
    @IBOutlet weak var colorContainerView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorTitleLabel: VFGLabel!

    func setupUI(color: UIColor, text: String?, isSelected: Bool) {
        if isSelected {
            selectColor(color: color, text: text)
        } else {
            unSelectColor(color: color, text: text)
        }
        setupAccessibilityLabels()
    }

    private func selectColor(color: UIColor, text: String?) {
        colorView.backgroundColor = color
        colorTitleLabel.text = text
        colorTitleLabel.font = UIFont.vodafoneBold(14.6)
        colorContainerView.layer.borderWidth = 2.1
        colorContainerView.layer.borderColor = UIColor.VFGSelectedInputOutline.cgColor
    }

    private func unSelectColor(color: UIColor, text: String?) {
        colorView.backgroundColor = color
        colorTitleLabel.text = text
        colorTitleLabel.font = UIFont.vodafoneRegular(14.6)
        colorContainerView.layer.borderWidth = 1
        colorContainerView.layer.borderColor = UIColor.VFGDefaultSelectionOutline.cgColor
    }

    private func setupAccessibilityLabels() {
        [colorContainerView, colorView, colorTitleLabel]
            .forEach { $0?.isAccessibilityElement = false }
        isAccessibilityElement = true
        accessibilityLabel = colorTitleLabel.text
    }
}
