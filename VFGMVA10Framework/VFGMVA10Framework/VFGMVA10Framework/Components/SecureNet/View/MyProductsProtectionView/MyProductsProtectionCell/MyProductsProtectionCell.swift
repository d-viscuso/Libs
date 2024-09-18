//
//  MyProductsProtectionCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 13/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class MyProductsProtectionCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var myProductsTitleLabel: VFGLabel!
    @IBOutlet weak var devicesStackView: UIStackView!
    /// An instance of *VFGMyProductsProtectionModel.Card*
    var card: VFGMyProductsProtectionModel.Card?
    weak var delegate: VFGMyProductsProtectionProtocol?

    func setup(with card: VFGMyProductsProtectionModel.Card) {
        self.card = card
        shadowView.configureShadow()
        containerView.layer.masksToBounds = true
        myProductsTitleLabel.text = card.title
        guard let devices = card.devices else { return }
        setupDevices(with: devices)
    }

    private func setupDevices(with devices: [VFGMyProductsProtectionModel.Card.Device]) {
        devicesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for device in devices {
            guard let deviceItemView = DeviceItemView.loadXib(
                bundle: .mva10Framework,
                nibName: String(describing: DeviceItemView.self)
            ) as? DeviceItemView else {
                continue
            }
            deviceItemView.setup(with: device)
            deviceItemView.deviceButtonAction = delegate?.devicesActions()[device.actionId ?? ""]
            devicesStackView.addArrangedSubview(deviceItemView)
        }
    }
}
