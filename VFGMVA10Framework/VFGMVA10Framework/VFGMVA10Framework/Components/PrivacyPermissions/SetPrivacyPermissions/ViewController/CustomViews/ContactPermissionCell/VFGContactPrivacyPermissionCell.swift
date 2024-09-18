//
//  VFGContactPrivacyPermissionCell.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 27/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGContactPrivacyPermissionCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var permissionTitleLabel: VFGLabel!
    @IBOutlet weak var toggleButton: VFGButton!
    @IBOutlet weak var seperatorView: UIView!

    weak var delegate: VFGPrivacyPermissionsSettingsProtocol?
    var indexPath: IndexPath?
    var buttonToggledOn = true {
        didSet {
            if buttonToggledOn {
                toggleButton.setImage(
                    UIImage.VFGToggle.Medium.active,
                    for: .normal)
            } else {
                toggleButton.setImage(
                    UIImage.VFGToggle.Medium.inactive,
                    for: .normal)
            }
        }
    }

    // MARK: setup
    func setup(with model: VFGContactPrivacyPermissionCellUIModel, indexPath: IndexPath, delegate: VFGPrivacyPermissionsSettingsProtocol? = nil) {
        self.delegate = delegate
        self.indexPath = indexPath
        permissionTitleLabel.text = model.contact.title
        toggleButton.setTitle("", for: .normal)
        buttonToggledOn = model.contact.toggleState
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        permissionTitleLabel.accessibilityLabel = permissionTitleLabel.text ?? ""
        contactCellToggleButtonVoiceOverSetup()
        accessibilityElements = [
            permissionTitleLabel ?? "",
            toggleButton ?? ""
        ]
        accessibilityCustomActions = [contactCellToggleButtonVoiceAction()]
    }

    // MARK: Action
    @IBAction func didPressedToggleButton(_ sender: Any) {
        contactCellToggleButtonPressed()
    }
    @objc func contactCellToggleButtonPressed() {
        guard let value = delegate?.didPressToggleButton(indexPath: indexPath) else {
            return
        }
        buttonToggledOn = value
        contactCellToggleButtonVoiceOverSetup()
    }
    func contactCellToggleButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = buttonToggledOn ? "Turn off" : "Turn on"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(contactCellToggleButtonPressed)
        )
    }
    func contactCellToggleButtonVoiceOverSetup() {
        var label = ""
        var hint = ""
        if buttonToggledOn {
            label = "Toggled on"
            hint = "permission is enabled, tap if you want to turn off permission"
        } else {
            label = "Toggled off"
            hint = "permission is disabled, tap if you want to turn on permission"
        }
        toggleButton.accessibilityLabel = label
        toggleButton.accessibilityHint = hint
    }
}
