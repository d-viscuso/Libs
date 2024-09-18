//
//  VFGProfilePrivacyPermissionCell.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 27/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol VFGPrivacyPermissionsSettingsProtocol: AnyObject {
    func didPressToggleButton(indexPath: IndexPath?) -> Bool?
}

class VFGProfilePrivacyPermissionCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var toggleButton: VFGButton!
    @IBOutlet weak var descriptionLabel: VFGLabel!
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

    // MARK: Setup
    func setup(with model: VFGProfilePrivacyPermissionCellUIModel, indexPath: IndexPath, delegate: VFGPrivacyPermissionsSettingsProtocol? = nil) {
        self.delegate = delegate
        self.indexPath = indexPath
        let permissionProfileImageName = model.permissionProfile.image
        iconImageView.image = VFGImage(named: permissionProfileImageName)
        titleLabel.text = model.permissionProfile.title
        descriptionLabel.text = model.permissionProfile.subtitle
        buttonToggledOn = model.permissionProfile.toggleState
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        iconImageView.accessibilityLabel = titleLabel.text ?? ""
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        profileCellToggleButtonVoiceOverSetup()
        accessibilityElements = [
            iconImageView ?? "",
            titleLabel ?? "",
            descriptionLabel ?? "",
            toggleButton ?? ""
        ]
        accessibilityCustomActions = [profileCellToggleButtonVoiceAction()]
    }

    // MARK: Actions
    @IBAction func didPressToggleButton(_ sender: Any) {
        profileCellToggleButtonPressed()
    }
    @objc func profileCellToggleButtonPressed() {
        guard let value = delegate?.didPressToggleButton(indexPath: indexPath) else {
            return
        }
        buttonToggledOn = value
        profileCellToggleButtonVoiceOverSetup()
    }
    func profileCellToggleButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = buttonToggledOn ? "Turn off" : "Turn on"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(profileCellToggleButtonPressed)
        )
    }
    func profileCellToggleButtonVoiceOverSetup() {
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
