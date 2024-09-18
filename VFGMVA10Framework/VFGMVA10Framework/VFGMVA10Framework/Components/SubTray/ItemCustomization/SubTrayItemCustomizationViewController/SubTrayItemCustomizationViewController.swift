//
//  SubTrayItemCustomizationViewController.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 12/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// View controller responsible for sub tray items customization
class SubTrayItemCustomizationViewController: UIViewController {
    @IBOutlet weak var itemTitleLabel: VFGLabel!
    @IBOutlet weak var itemDescriptionLabel: VFGLabel!
    @IBOutlet weak var itemBackgroundView: UIView!
    @IBOutlet weak var itemIconImageView: VFGImageView!
    @IBOutlet weak var renameDeviceLabel: VFGLabel!
    @IBOutlet weak var deviceNameTextField: VFGTextField!
    @IBOutlet weak var setDefaultTitleLabel: VFGLabel!
    @IBOutlet weak var setDefaultDescriptionLabel: VFGLabel!
    @IBOutlet weak var setDefaultImageView: VFGImageView!
    @IBOutlet weak var setDefaultButton: VFGButton!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!
    /// Delegation for *SubTrayCustomizationManager* navigation actions
    weak var navigationDelegate: SubTrayCustomizationManagerNavigationDelegate?
    /// sub tray item data model
    var subTrayItem: VFGSubTrayItem?
    /// Determine if current sub tray item is the default item or not
    var isDefault = false {
        didSet {
            setupDefaultImage(isDefault)
        }
    }
    var deviceNameTextFieldMaxLength = 17

    public override func viewDidLoad() {
        super.viewDidLoad()

        deviceNameTextField.delegate = self
        setupText()
        setupUI()
        setupFonts()
    }

    private func setupUI() {
        itemBackgroundView.roundCorners()
        primaryButton.isEnabled = false
        setDefaultButton.isEnabled = !(subTrayItem?.isDefault ?? false)
    }

    private func setupText() {
        itemTitleLabel.text = subTrayItem?.title?.localized(bundle: .mva10Framework)
        itemDescriptionLabel.text = subTrayItem?.subTitle?.localized(bundle: .mva10Framework)
        itemIconImageView.image = subTrayItem?.image
        renameDeviceLabel.text =
            "sub_tray_customization_rename_device_title".localized(bundle: .mva10Framework)
        setDefaultTitleLabel.text =
            "sub_tray_customization_set_default_device_title".localized(bundle: .mva10Framework)
        setDefaultDescriptionLabel.text
            = "sub_tray_customization_set_default_device_subtitle".localized(bundle: .mva10Framework)
        primaryButton.setTitle(
            "sub_tray_customization_save_button_title".localized(bundle: .mva10Framework),
            for: .normal)
        secondaryButton.setTitle(
            "sub_tray_customization_cancel_button_title".localized(bundle: .mva10Framework),
            for: .normal)

        deviceNameTextField.configureTextField(
            topTitleText: "sub_tray_customization_device_name_hint_title".localized(bundle: .mva10Framework),
            placeHolder: "sub_tray_customization_device_name_placeholder_title".localized(bundle: .mva10Framework),
            counterMaxLength: deviceNameTextFieldMaxLength)
        deviceNameTextField.textFieldText = subTrayItem?.title?.localized(bundle: .mva10Framework) ?? ""
        setupDefaultImage(isDefault)
    }

    private func setupFonts() {
        itemTitleLabel.font = .vodafoneBold(16.6)
        itemDescriptionLabel.font = .vodafoneRegular(14.6)
        renameDeviceLabel.font = .vodafoneLite(25)
        setDefaultTitleLabel.font = .vodafoneRegular(16.6)
        setDefaultDescriptionLabel.font = .vodafoneRegular(14.6)
        primaryButton.titleLabel?.font = .vodafoneRegular(18.7)
        secondaryButton.titleLabel?.font = .vodafoneRegular(18.7)
    }

    private func setupDefaultImage(_ isDefault: Bool) {
        let iconName = isDefault ? "icStarEnabled" : "icStarDisabled"
        setDefaultImageView?.image = VFGImage(named: iconName)
        setDefaultImageView?.tintColor = isDefault ? .VFGActiveSelectionOutline : .VFGDefaultSelectionOutline
    }
    /// *SubTrayItemCustomizationViewController* configuration
    /// - Parameters:
    ///    - subTrayItem: sub tray item data model
    ///    - deviceNameTextFieldMaxLength: Max munber of allowed characters to enter in device name text field
    ///    - navigationDelegate: Delegation for *SubTrayCustomizationManager* navigation actions
    public func configure(
        subTrayItem: VFGSubTrayItem,
        deviceNameTextFieldMaxLength: Int,
        navigationDelegate: SubTrayCustomizationManagerNavigationDelegate?
    ) {
        self.subTrayItem = subTrayItem
        self.deviceNameTextFieldMaxLength = deviceNameTextFieldMaxLength
        self.isDefault = subTrayItem.isDefault ?? false
        self.navigationDelegate = navigationDelegate
    }
    /// Determine whether primary button should be enabled or not
    func updatePrimaryButtonState() {
        if !primaryButton.isEnabled {
            primaryButton.isEnabled = true
        }
    }

    @IBAction func setDefaultButtonDidPress(_ sender: VFGButton) {
        isDefault.toggle()
        updatePrimaryButtonState()
    }

    @IBAction func primaryButtonDidPress(_ sender: VFGButton) {
        navigationDelegate?.finish(
            state: .customization(
                newName: deviceNameTextField.textFieldText,
                isDefault: isDefault
            )
        )
    }

    @IBAction func secondaryButtonDidPress(_ sender: VFGButton) {
        navigationDelegate?.terminate(state: .customization(newName: "", isDefault: false))
    }
}
