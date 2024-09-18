//
//  VFGPrivacyPermissionTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 13/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol VFGPrivacyPermissionTableViewCellProtocol: AnyObject {
    func didPressOnToggle(for indexPath: IndexPath)
}

class VFGPrivacyPermissionTableViewCell: UITableViewCell {
    @IBOutlet weak var imageIcon: VFGImageView!
    @IBOutlet weak var title: VFGLabel!
    @IBOutlet weak var descriptionText: VFGLabel!
    @IBOutlet weak var toggleButton: VFGButton!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var itemContainer: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var permanentStateLabel: VFGLabel!
    @IBOutlet weak var separatorLeadingConstraint: NSLayoutConstraint!
    private var initialContainerTopMargin: CGFloat = 12
    private var initialContainerBottomMargin: CGFloat = 12
    private var initialSubtitleBottomMargin: CGFloat = 24
    private var initialSeparatorLeadingMargin: CGFloat = 20

    weak var delegate: VFGPrivacyPermissionTableViewCellProtocol?
    var indexPath: IndexPath?
    var buttonToggledOn = false {
        didSet {
            if buttonToggledOn {
                toggleButton.setImage(
                    UIImage.VFGToggle.Medium.active,
                    for: .normal)
                toggleButton.accessibilityLabel = "turned on toggle"
            } else {
                toggleButton.setImage(
                    UIImage.VFGToggle.Medium.inactive,
                    for: .normal)
                toggleButton.accessibilityLabel = "turned off toggle"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        enableAccessibility()
    }

    private func enableAccessibility() {
        title.isAccessibilityElement = true
        descriptionText.isAccessibilityElement = true
        permanentStateLabel.isAccessibilityElement = true
        imageIcon.isAccessibilityElement = true
    }

    // MARK: Setup
    func setup(with model: PermissionProfile, indexPath: IndexPath, delegate: VFGPrivacyPermissionTableViewCellProtocol? = nil) {
        containerTopConstraint.constant = initialContainerTopMargin
        containerBottomConstraint.constant = initialContainerBottomMargin
        subtitleBottomConstraint.constant = initialSubtitleBottomMargin
        separatorLeadingConstraint.constant = initialSeparatorLeadingMargin
        self.delegate = delegate
        self.indexPath = indexPath
        let permissionProfileImageName = model.image
        imageIcon.image = VFGImage(named: permissionProfileImageName)
        imageIcon.accessibilityValue = model.imageDescription ?? ""
        title.text = model.title
        descriptionText.text = model.subtitle
        if model.isToggle ?? true {
            buttonToggledOn = model.state
            permanentStateLabel.isHidden = true
            toggleButton.isHidden = false
        } else {
            toggleButton.isHidden = true
            permanentStateLabel.isHidden = false
            // TODO: add on, off localization
            permanentStateLabel.text = model.state ?
            "privacy_settings_third_party_apps_permission_on".localized(bundle: .mva10Framework) :
            "privacy_settings_third_party_apps_permission_off".localized(bundle: .mva10Framework)
        }
        separator.isHidden = true
        if model.subtitle?.isEmpty ?? true {
            subtitleBottomConstraint.constant = 0
        }
    }

    // MARK: Actions
    @IBAction func toggleButtonDidPress(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        delegate?.didPressOnToggle(for: indexPath)
    }
}
