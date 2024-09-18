//
//  VFPermissionCard.swift
//  VFGMVA10Group
//
//  Created by Mohamed Abd ElNasser on 6/26/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFPermissionViewCard: UIView {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var icon: VFGImageView!
    @IBOutlet weak var cardTitle: VFGLabel!
    @IBOutlet weak var cardText: UITextView!
    @IBOutlet weak var toggleButton: VFGButton!
    @IBOutlet weak var statusLabel: VFGLabel!
    @IBOutlet weak var requestTextView: UITextView!
    @IBOutlet weak var requestStackView: UIStackView!
    @IBOutlet weak var fullBottomSeperator: UIView!
    @IBOutlet weak var fullTopSeperator: UIView!
    @IBOutlet weak var croppedTopSeparator: UIView!
    @IBOutlet weak var croppedTopSeparatorLeftConstraint: NSLayoutConstraint?

    var permissionCardViewModel: VFPermissionCardViewModel?

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
            toggleButton.accessibilityValue = buttonToggledOn ? "On" : "Off"
        }
    }
    @IBAction func toggleButtonClicked(_ sender: Any) {
        buttonToggleAction()
    }

    @objc func buttonToggleAction() {
        buttonToggledOn.toggle()
        permissionCardViewModel?.permissionStatus = buttonToggledOn == true ? .allowed : .denied
        permissionCardViewModel?.toggleValueChanged?(buttonToggledOn)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cardTitle.font = UIFont.vodafoneRegular(18)
        cardText.font = UIFont.vodafoneRegular(14)
        cardText.textContainer.lineFragmentPadding = 0
        cardText.textContainerInset = .zero
        toggleButton.setImage(UIImage.VFGToggle.Medium.active, for: .normal)
        if UIApplication.isRightToLeft {
            toggleButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }

    func configureForSettings(
        with permissionCardViewModel: VFPermissionCardViewModel,
        isReadOnly: Bool,
        isFirstCell: Bool? = nil,
        accessibilityIdentifierPrefix: String
    ) {
        setMainCardElements(permissionCardViewModel)
        croppedTopSeparator.backgroundColor = .VFGGreyDividerSix

        if isReadOnly {
            // Show label if this card is for DevicePermission view
            statusLabel.isHidden = false
            statusLabel.text = statusAsString()
            croppedTopSeparatorLeftConstraint?.constant = 0
            // hide not used elements
            toggleButton.isHidden = true
        } else if !isReadOnly {
            toggleButton.isHidden = false
            buttonToggledOn = permissionCardViewModel.permissionStatus == .allowed ? true : false

            // hide not used elements
            statusLabel.isHidden = true
        }

        if isFirstCell == false {
            croppedTopSeparator.isHidden = false
        }
        setAccessibilityIdentifier(accessibilityIdentifierPrefix, isReadOnly)
    }

    func configureForOnboarding(
        with permissionCardViewModel: VFPermissionCardViewModel,
        isFirstCell: Bool
    ) {
        setMainCardElements(permissionCardViewModel)
        var offStatus: [VFGPermissionStatus] = [.denied]
        if permissionCardViewModel.defaultStatus == false {
            offStatus.append(.notDetermined)
        }

        toggleButton.isHidden = false
        if let status = permissionCardViewModel.permissionStatus {
            buttonToggledOn = !offStatus.contains(status)
        } else {
            buttonToggledOn = false
        }

        // hide not used elements
        statusLabel.isHidden = true

        fullBottomSeperator.isHidden = false
        setAccessibilityIdentifier("OB", false)
        if isFirstCell {
            fullTopSeperator.isHidden = false
        }
    }

    private func setMainCardElements(_ permissionCardViewModel: VFPermissionCardViewModel) {
        self.permissionCardViewModel = permissionCardViewModel

        tag = permissionCardViewModel.cardIndex
        icon.image = permissionCardViewModel.icon
        cardTitle.text = permissionCardViewModel.title
        cardText.text = permissionCardViewModel.description
        cardText.sizeToFit()
        cardText.textContainerInset = .zero
        requestStackView.isHidden = true
    }

    private func setAccessibilityIdentifier(
        prefix: String,
        suffix: String,
        type: String,
        statusOrToggle: UIView
    ) {
        icon.accessibilityIdentifier = prefix + type + "Icon"
        cardTitle.accessibilityIdentifier = prefix + type + "Title"
        cardText.accessibilityIdentifier = prefix + type + "Description"
        let permissionName = cardTitle.text?.replacingOccurrences(of: " ", with: "") ?? ""
        statusOrToggle.accessibilityIdentifier = prefix + permissionName + suffix
        statusOrToggle.accessibilityValue = buttonToggledOn ? "On" : "Off"
        self.accessibilityIdentifier = prefix + type + "Card"
    }

    func setAccessibilityIdentifier(_ accessibilityIdentifierPrefix: String, _ isReadOnly: Bool) {
        guard let permissionCardViewModel = permissionCardViewModel else {
            return
        }

        let prefix = accessibilityIdentifierPrefix
        let suffix = isReadOnly ? "Label" : "Toggle"
        let statusOrToggle = isReadOnly ? statusLabel : toggleButton
        var type = ""

        switch permissionCardViewModel.type {
        case .contacts:
            type = "contact"
        case .pushNotifications:
            type = "push"
        case .locationWhileUsage, .locationAlways:
            type = "location"
        case .network:
            type = "network"
        case .custom(let customType):
            type = customType
        }

        setAccessibilityIdentifier(
            prefix: prefix,
            suffix: suffix,
            type: type,
            statusOrToggle: statusOrToggle ?? UIView())
        setAccessibilityForVocieOver(isReadOnly: isReadOnly)
    }

    func statusAsString() -> String {
        switch permissionCardViewModel?.permissionStatus {
        case .allowed:
            return "device_permission_toggle_on".localized(bundle: .mva10Framework)
        case .denied:
            return "device_permission_toggle_off".localized(bundle: .mva10Framework)
        case .notDetermined, .none:
            configureRequestTextView()
            return ""
        }
    }

    func configureRequestTextView() {
        // Add hyperLink to description text
        requestStackView.isHidden = false
        var target: VFGDevicePermissionTarget?
        switch permissionCardViewModel?.type {
        case .contacts:
            target = .requestContact
            requestTextView.accessibilityIdentifier = "DPswitchContactSync"
        case .locationWhileUsage:
            target = .requestLocation
            requestTextView.accessibilityIdentifier = "DPswitchLocationSync"
        case .pushNotifications:
            target = .requestPushNotifications
            requestTextView.accessibilityIdentifier = "DPswitchPushSync"
        default:
            break
        }

        guard let permissionTarget = target else {
            return
        }
        let originalText = "permissions_request_hypertext".localized(bundle: Bundle.mva10Framework)
        requestTextView.hyperLink(
            originalText: originalText,
            hyperLinks: [
                (link: originalText, target: permissionTarget.rawValue)
            ],
        linkColor: UIColor.VFGLinkText,
        font: UIFont.vodafoneRegular(15))
    }
}
