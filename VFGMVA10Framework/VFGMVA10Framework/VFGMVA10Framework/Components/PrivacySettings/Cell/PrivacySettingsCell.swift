//
//  PrivacySettingsCell.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 11/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Privacy settings main screen cell
class PrivacySettingsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var actionIcon: VFGImageView!
    @IBOutlet weak var actionTitle: VFGLabel!
    @IBOutlet weak var privacySettingsButton: VFGButton!
    /// Hold the action of the selected button in privacy settings main screen cell
    var privacySettingsButtonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        enableAccessibility()
    }

    @IBAction func privacySettingsButtonDidPress(_ sender: VFGButton) {
        privacySettingsButtonAction?()
    }
    /// *PrivacySettingsCell* data configuration
    /// - Parameters:
    ///    - model: Hold privacy settings cell data model
    func configure(with model: PrivacySettingsContentModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        actionIcon.image = VFGImage(named: model.actionIcon)
        actionTitle.text = model.actionTitle
        setVoiceOverAccessibility(model: model)
    }

    private func enableAccessibility() {
        titleLabel.isAccessibilityElement = true
        subtitleLabel.isAccessibilityElement = true
        actionTitle.isAccessibilityElement = true
        privacySettingsButton.isAccessibilityElement = true
        actionIcon.isAccessibilityElement = true
    }

    private func setVoiceOverAccessibility(model: PrivacySettingsContentModel) {
        titleLabel.accessibilityLabel = model.title
        subtitleLabel.accessibilityLabel = model.description
        actionTitle.accessibilityLabel = model.actionTitle
        privacySettingsButton.accessibilityLabel = "Navigate to \(model.actionTitle)"
        actionIcon.accessibilityLabel = model.actionIconDescription ?? ""
    }

    private func addShadow() {
        actionView.configureShadow(
            offset: CGSize(width: 0.0, height: 2.0),
            radius: 8.0,
            opacity: 0.16,
            shouldRasterize: false)
    }
}
