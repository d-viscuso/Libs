//
//  VFGDeviceContinueCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 24/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

protocol VFGDeviceContinueCellDelegate: AnyObject {
    func continueButtonDidPress()
}

class VFGDeviceContinueCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var continueButton: VFGButton!
    // MARK: - Attributes
    weak var delegate: VFGDeviceContinueCellDelegate?

    func setupUI() {
        continueButton.setTitle(
            "device_upgrade_device_step_cta_button_title".localized(bundle: .mva10Framework),
            for: .normal
        )
        setupAccessibilityIDs()
    }

    private func setupAccessibilityIDs() {
        continueButton.accessibilityIdentifier = "DContinueToNextStepButton"
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        delegate?.continueButtonDidPress()
    }
}
