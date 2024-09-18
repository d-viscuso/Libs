//
//  VFGChooseDeviceCollectionCell.swift
//  VFGMVA10Framework
//
//  Created by Moamen Abd Elgawad on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class VFGChooseDeviceCollectionCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deviceIconImageView: VFGImageView!
    @IBOutlet weak var brandLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var fromLabel: VFGLabel!
    @IBOutlet weak var upfrontLabel: VFGLabel!
    @IBOutlet weak var perMonthLabel: VFGLabel!
    @IBOutlet weak var upfrontPriceLabel: VFGLabel!
    @IBOutlet weak var recurringPriceLabel: VFGLabel!
    @IBOutlet weak var chooseButton: VFGButton!
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var cellMainContentView: UIView!

    public var chooseButtonDidPress: (() -> Void)?

    public override func awakeFromNib() {
        super.awakeFromNib()
        chooseButton.roundCorners()
        setupAccessibilityIDs()
    }

    private func setupAccessibilityIDs() {
        deviceIconImageView.accessibilityIdentifier = "CDCollectionCellImage"
        titleLabel.accessibilityIdentifier = "CDCollectionCellPhoneModel"
        upfrontPriceLabel.accessibilityIdentifier = "CDCollectionCellUpfrontPrice"
        recurringPriceLabel.accessibilityIdentifier = "CDCollectionCellRecurringPrice"
        chooseButton.accessibilityIdentifier = "CDCollectionCellChooseButton"
    }

    public func setupCell(
        brand: String? = nil,
        title: String? = nil,
        currencySymbol: String = "€",
        upfrontPrice: Int?,
        recurringPrice: Int?,
        imageUrl: String?,
        isRecommended: Bool?,
        isSelected: Bool
    ) {
        brandLabel.text = brand
        titleLabel.text = title

        upfrontPriceLabel.text = "\(upfrontPrice ?? 0)"
        recurringPriceLabel.text = "\(recurringPrice ?? 0)\(currencySymbol)"
        fromLabel.text = "device_upgrade_choose_step_price_from".localized(bundle: .mva10Framework)
        upfrontLabel.text = "device_upgrade_choose_step_price_upfront".localized(bundle: .mva10Framework)
        perMonthLabel.text = "/\("device_upgrade_choose_step_price_per_month".localized(bundle: .mva10Framework))"
        deviceIconImageView.image = VFGImage(named: imageUrl ?? "")

        if isRecommended ?? false {
            recommendView.isHidden = false
            recommendLabel.text = "device_upgrade_recommended_title".localized(bundle: .mva10Framework)
            cellMainContentView.layer.borderWidth = 1
            cellMainContentView.layer.borderColor = UIColor.VFGAquaBackground.cgColor
            cellMainContentView.roundBottomAndRightCorners(cornerRadius: 6)
        } else {
            recommendView.isHidden = true
            cellMainContentView.layer.borderWidth = 0
            cellMainContentView.roundCorners()
        }

        if isSelected {
            selected()
        } else {
            unSelected()
        }
        addShadow()
        setupAccessibilityLabels()
    }

    public func setupCell(with device: ChooseDeviceModel.Device, isSelected: Bool) {
        setupCell(
            brand: device.brand,
            title: device.title,
            upfrontPrice: device.price?.upfrontPrice,
            recurringPrice: device.price?.recurringPrice,
            imageUrl: device.imageUrl,
            isRecommended: device.isRecommended,
            isSelected: isSelected)
    }

    func selected() {
        chooseButton.setTitle(
            "device_upgrade_choose_step_selected".localized(bundle: .mva10Framework),
            for: .normal
        )
        chooseButton.backgroundColor = .VFGSecondaryButton
        chooseButton.setTitleColor(.VFGSecondaryButtonText, for: .normal)
        chooseButton.layer.borderWidth = 1
        chooseButton.layer.borderColor = UIColor.VFGSecondaryButtonOutline.cgColor
    }

    func unSelected() {
        chooseButton.setTitle(
            "device_upgrade_choose_step_cta_button_title".localized(bundle: .mva10Framework),
            for: .normal
        )
        chooseButton.backgroundColor = .VFGTertiaryButton
        chooseButton.setTitleColor(.VFGTertiaryButtonActiveText, for: .normal)
        chooseButton.layer.borderWidth = 0
    }

    @IBAction func chooseButtonDidPress(_ sender: Any) {
        chooseButtonDidPress?()
    }

    @objc func chooseButtonAction() {
        chooseButtonDidPress?()
    }
}

extension VFGChooseDeviceCollectionCell {
    func addShadow() {
        cellMainContentView.addingShadow(size: CGSize(width: 0, height: 2), radius: 4, opacity: 0.16)
    }
}

extension VFGChooseDeviceCollectionCell {
    func setupAccessibilityLabels() {
        brandLabel.accessibilityLabel = brandLabel.text ?? ""
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        upfrontPriceLabel.accessibilityLabel = upfrontPriceLabel.text ?? ""
        recurringPriceLabel.accessibilityLabel = recurringPriceLabel.text ?? ""
        fromLabel.accessibilityLabel = "device_upgrade_choose_step_price_from".localized(bundle: .mva10Framework)
        upfrontLabel.accessibilityLabel = "device_upgrade_choose_step_price_upfront".localized(bundle: .mva10Framework)
        chooseButton.accessibilityLabel = "device_upgrade_choose_step_selected".localized(bundle: .mva10Framework)
        perMonthLabel.accessibilityLabel = "device_upgrade_choose_step_price_per_month"
            .localized(bundle: .mva10Framework)
        accessibilityCustomActions = [chooseVoiceOverAction()]
    }
    /// action for choose device voice over
    /// - Returns: action for choose device  button in voice over
    func chooseVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "choose"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(chooseButtonAction))
    }
}
