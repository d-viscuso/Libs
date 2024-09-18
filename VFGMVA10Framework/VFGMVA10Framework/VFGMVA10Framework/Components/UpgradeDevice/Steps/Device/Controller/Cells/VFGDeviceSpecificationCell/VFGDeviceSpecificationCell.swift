//
//  VFGDeviceSpecificationCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 24/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGDeviceSpecificationCell: UITableViewCell {
    @IBOutlet weak var specificationView: VFGDeviceSpecificationView!
    @IBOutlet weak var inboxTitleLabel: VFGLabel!
    @IBOutlet weak var inboxValueLabel: VFGLabel!
    @IBOutlet weak var showFullSpecificationsLabel: VFGLabel!
    @IBOutlet weak var showFullSpecificationsButton: VFGButton!

    weak var dataSource: VFGDeviceViewModelSpecificationsDataSource? {
        didSet {
            specificationView.dataSource = dataSource
            updateBoxDetailsLabels(with: dataSource?.boxDetails ?? [])
        }
    }

    var showFullSpecsDidPress: (() -> Void)?

    func updateBoxDetailsLabels(with values: [String]) {
        showFullSpecificationsLabel.text = "device_upgrade_device_step_show_full_specifications_button_title"
            .localized(bundle: .mva10Framework)
        let updatedValues = values.map { "• " + $0 }
        let text = updatedValues.joined(separator: "\n")
        inboxValueLabel.text = text
        inboxTitleLabel.text = "device_upgrade_device_step_in_box".localized(bundle: .mva10Framework)
        setupAccessibilityLabels()
        layoutIfNeeded()
    }

    @IBAction func showFullSpecsDidPress(_ sender: UIButton) {
        showFullSpecsDidPress?()
    }

    private func setupAccessibilityLabels() {
        isAccessibilityElement = false
        showFullSpecificationsLabel.isAccessibilityElement = false
        showFullSpecificationsButton.isAccessibilityElement = true
        showFullSpecificationsButton.accessibilityLabel = showFullSpecificationsLabel.text
        showFullSpecificationsButton.accessibilityIdentifier = "UDFullSpecificationsButtonID"
        guard
            let specificationView = specificationView,
            let inboxTitleLabel = inboxTitleLabel,
            let inboxValueLabel = inboxValueLabel,
            let showFullSpecificationsButton = showFullSpecificationsButton
        else { return }
        accessibilityElements = [specificationView, inboxTitleLabel, inboxValueLabel, showFullSpecificationsButton]
    }
}
