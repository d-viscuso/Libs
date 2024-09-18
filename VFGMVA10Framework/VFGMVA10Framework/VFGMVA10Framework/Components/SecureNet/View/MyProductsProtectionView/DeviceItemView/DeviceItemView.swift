//
//  DeviceItemView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 13/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class DeviceItemView: UIView {
    @IBOutlet weak var deviceImage: VFGImageView!
    @IBOutlet weak var deviceTitleLabel: VFGLabel!
    @IBOutlet weak var deviceProtectionStatusLabel: VFGLabel!
    @IBOutlet weak var deviceProtectionStatusImage: VFGImageView!
    @IBOutlet weak var deviceActionButton: VFGButton!

    var deviceButtonAction: (() -> Void)?

    func setup(with device: VFGMyProductsProtectionModel.Card.Device) {
        deviceImage.image = VFGImage(named: device.iconKey)
        deviceTitleLabel.text = device.title
        deviceProtectionStatusLabel.text = getStatusLabel(status: device.isProtected)
        deviceProtectionStatusImage.image = getStatusImage(status: device.isProtected)
    }

    private func getStatusLabel(status: Bool?) -> String {
        if status ?? false {
            return "secure_net_my_products_protected_status".localized(bundle: .mva10Framework)
        }
        return "secure_net_my_products_unprotected_status".localized(bundle: .mva10Framework)
    }

    private func getStatusImage(status: Bool?) -> UIImage {
        guard let status = status,
            let image = status ? VFGFrameworkAsset.Image.icActiveCircle : VFGFrameworkAsset.Image.icInActiveCircle
        else { return UIImage() }
        return image
    }

    @IBAction func onDeviceButtonDidPress(_ sender: VFGButton) {
        deviceButtonAction?()
    }
}
