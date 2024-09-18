//
//  VFGUpgradeDeviceCell.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/1/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGUpgradeDeviceCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var detailsLabel: VFGLabel!
    @IBOutlet weak var productItemHeaderStackView: VFGProductHeaderStackView!

    func setup(deviceDetails: ChooseDeviceModel.Device) {
        setupContainerViewUIStyle()
        productItemHeaderStackView.setup(
            productHeader: VFGProductHeaderUIModel(
                imageURL: deviceDetails.imageUrl ?? "",
                name: (text: deviceDetails.brand ?? "", font: UIFont.vodafoneRegular(15)),
                description: (text: deviceDetails.title ?? "", font: UIFont.vodafoneBold(18))
            )
        )

        guard let size = deviceDetails.capacity?.size,
            let sizeUnit = deviceDetails.capacity?.sizeUnit,
                let colorName = deviceDetails.color?.colorName else {
            return
        }

        detailsLabel.text = "\(size) \(sizeUnit) - \(colorName)"
        setupAccessibilityLabel()
    }

    private func setupContainerViewUIStyle() {
        containerView.roundCorners()
        containerView.addingShadow(size: CGSize(width: 0, height: 2), radius: 4, opacity: 0.16)
    }
}

extension VFGUpgradeDeviceCell {
    func setupAccessibilityLabel() {
        detailsLabel.accessibilityLabel = detailsLabel.text ?? ""
    }
}
