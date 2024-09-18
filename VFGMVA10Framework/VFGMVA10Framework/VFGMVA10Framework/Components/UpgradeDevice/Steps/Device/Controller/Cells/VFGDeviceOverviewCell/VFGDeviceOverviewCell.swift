//
//  VFGDeviceOverviewCell.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 17/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
import WebKit

class VFGDeviceOverviewCell: UITableViewCell {
    @IBOutlet weak var deviceOverviewLabel: VFGLabel!
    @IBOutlet weak var deviceOverviewButton: VFGButton!
    let deviceOverviewText = "device_upgrade_device_step_device_overview".localized(bundle: .mva10Framework)
    let webUrl = "https://www.vodafone.co.uk/mobile/phones/pay-monthly-contracts/apple/iphone-12-pro-max"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupAccessibilityLabel()
    }

    func setupUI() {
        deviceOverviewLabel.text = deviceOverviewText
    }

    @IBAction func deviceOverviewDidPress(_ sender: UIButton) {
        let viewModel = VFGWebViewModel(
            urlString: webUrl,
            shouldShowHeaderView: true,
            title: deviceOverviewText)
        let webViewController = VFGWebViewController.instance(with: viewModel)
        UIApplication.topViewController()?.present(webViewController, animated: true, completion: nil)
    }

    private func setupAccessibilityLabel() {
        isAccessibilityElement = false
        deviceOverviewLabel.isAccessibilityElement = false
        deviceOverviewButton.isAccessibilityElement = true
        deviceOverviewButton.accessibilityIdentifier = "DOverviewCellButtonID"
        deviceOverviewButton.accessibilityLabel = deviceOverviewText
    }
}
