//
//  VFGDisplayOptionsCell.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 4/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Delegation for *VFGDisplayOptionsCell* actions
public protocol VFGDisplayOptionsDelegate: AnyObject {
    /// Handle selecting another display style for app
    /// - Parameters:
    ///    - value: New chosen display style for app
    func styleDidChange(to value: VFGDisplayOptions)
    /// App current display style
    func currentStyle() -> VFGDisplayOptions
}
/// Display options table view cell
class VFGDisplayOptionsCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var selectOptionLabel: VFGLabel!
    @IBOutlet weak var autoModeOptionButton: VFGButton!
    @IBOutlet weak var lightModeOptionButton: VFGButton!
    @IBOutlet weak var darkModeOptionButton: VFGButton!
    @IBOutlet weak var topSeparator: UIView!
    /// Delegation for *VFGDisplayOptionsCell* actions
    public weak var delegate: VFGDisplayOptionsDelegate? {
        didSet {
            selectDisplayOption(delegate?.currentStyle() ?? .auto)
        }
    }

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()

        setupLabelsFont()
        localizeLabels()

        setButtonsFont()
        setButtonsLabelColor()

        addShadowToCard()
        setAccessibilityIdentifiers()
        setAccessibilityForVoiceOver()
    }

    // MARK: - Private Methods
    private func addShadowToCard() {
        cardView.roundBottomCorners(cornerRadius: 6)
        cardView.addingShadow(size: CGSize(width: 0, height: 1), radius: 4, opacity: 0.16)
    }

    private func setupLabelsFont() {
        titleLabel.font = UIFont.vodafoneRegular(18)
        selectOptionLabel.font = UIFont.vodafoneRegular(14)
    }

    private func setButtonsLabelColor() {
        darkModeOptionButton.setTitleColor(.white, for: .selected)
        darkModeOptionButton.setTitleColor(.VFGPrimaryText, for: .normal)

        autoModeOptionButton.setTitleColor(.white, for: .selected)
        autoModeOptionButton.setTitleColor(.VFGPrimaryText, for: .normal)

        lightModeOptionButton.setTitleColor(.white, for: .selected)
        lightModeOptionButton.setTitleColor(.VFGPrimaryText, for: .normal)
    }

    private func setButtonsFont() {
        autoModeOptionButton.titleLabel?.font = UIFont.vodafoneRegular(18)
        lightModeOptionButton.titleLabel?.font = UIFont.vodafoneRegular(18)
        darkModeOptionButton.titleLabel?.font = UIFont.vodafoneRegular(18)
    }

    private func localizeLabels() {
        titleLabel.text =
            "display_options_display_mode_section_title".localized(
                bundle: .mva10Framework)
        selectOptionLabel.text =
            "display_options_display_mode_section_description".localized(
                bundle: .mva10Framework)
        autoModeOptionButton.setTitle(
            "display_options_mode_auto".localized(
                bundle: .mva10Framework),
                for: .normal)
        lightModeOptionButton.setTitle(
            "display_options_mode_light".localized(
                bundle: .mva10Framework),
                for: .normal)
        darkModeOptionButton.setTitle(
            "display_options_mode_dark".localized(
                bundle: .mva10Framework),
                for: .normal)
    }

    private func setAccessibilityIdentifiers() {
        autoModeOptionButton.accessibilityIdentifier = "DOautoModeButton"
        lightModeOptionButton.accessibilityIdentifier = "DOlightModeButton"
        darkModeOptionButton.accessibilityIdentifier = "DOdarkModeButton"
    }

    private func changeButtonsBackgroundColor(for displayOption: VFGDisplayOptions) {
        switch displayOption {
        case .auto:
            autoModeOptionButton.backgroundColor = .VFGDarkerAquaBackground

            lightModeOptionButton.backgroundColor = .clear
            darkModeOptionButton.backgroundColor = .clear

        case .light:
            lightModeOptionButton.backgroundColor = .VFGDarkerAquaBackground

            autoModeOptionButton.backgroundColor = .clear
            darkModeOptionButton.backgroundColor = .clear

        case .dark:
            darkModeOptionButton.backgroundColor = .VFGDarkerAquaBackground

            autoModeOptionButton.backgroundColor = .clear
            lightModeOptionButton.backgroundColor = .clear
        }
    }

    private func toggleButtons(for displayOption: VFGDisplayOptions) {
        switch displayOption {
        case .auto:
            autoModeOptionButton.isSelected = true
            darkModeOptionButton.isSelected = false
            lightModeOptionButton.isSelected = false

        case .light:
            lightModeOptionButton.isSelected = true
            darkModeOptionButton.isSelected = false
            autoModeOptionButton.isSelected = false
        case .dark:
            darkModeOptionButton.isSelected = true
            lightModeOptionButton.isSelected = false
            autoModeOptionButton.isSelected = false
        }
    }
    /// Handle selecting another display style actions
    /// - Parameters:
    ///    - displayOption: New chosen display style for app
    func selectDisplayOption(_ displayOption: VFGDisplayOptions) {
        toggleButtons(for: displayOption)
        changeButtonsBackgroundColor(for: displayOption)
        delegate?.styleDidChange(to: displayOption)
    }

    // MARK: - Actions
    @IBAction func autoModeOptionDidPress(_ sender: Any) {
        enableAutoModeOption()
    }

    @IBAction func lightModeOptionDidPress(_ sender: Any) {
        enableLightModeOption()
    }

    @IBAction func darkModeOptionDidPress(_ sender: Any) {
        enableDarkModeOption()
    }

    @objc func enableAutoModeOption() {
        selectDisplayOption(.auto)
    }

    @objc func enableLightModeOption() {
        selectDisplayOption(.light)
    }

    @objc func enableDarkModeOption() {
        selectDisplayOption(.dark)
    }
}

extension VFGDisplayOptionsCell {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        titleLabel.accessibilityLabel = titleLabel.text
        autoModeOptionButton.accessibilityLabel = autoModeOptionButton.title(for: .normal)
        lightModeOptionButton.accessibilityLabel = lightModeOptionButton.title(for: .normal)
        darkModeOptionButton.accessibilityLabel = darkModeOptionButton.title(for: .normal)
        selectOptionLabel.accessibilityLabel = selectOptionLabel.text
        accessibilityElements = [
            titleLabel,
            autoModeOptionButton,
            lightModeOptionButton,
            darkModeOptionButton,
            selectOptionLabel
        ].compactMap { $0 }
        accessibilityCustomActions = [
            enableAutoModeVoiceAction(),
            enableLightModeVoiceAction(),
            enableDarkModeVoiceAction()
        ]
    }

    /// action for autoMode button in voice over
    /// - Returns: action for autoMode button in voice over
    func enableAutoModeVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = "Enable auto mode"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(enableAutoModeOption))
    }

    /// action for light button in voice over
    /// - Returns: action for light button in voice over
    func enableLightModeVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = "Enable light mode"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(enableLightModeOption))
    }

    /// action for dark button in voice over
    /// - Returns: action for dark button in voice over
    func enableDarkModeVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = "Enable dark mode"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(enableDarkModeOption))
    }
}
