//
//  VFGTooltipCardView.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 15/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

class VFGTooltipCardView: UIView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var counterLabel: VFGLabel!
    @IBOutlet weak var button: VFGButton!
    @IBOutlet weak var dismissAllButton: VFGButton!

    var onButtonPress: (() -> Void)?
    var onDismiss: (() -> Void)?
    var onDismissAll: (() -> Void)?

    func configure(tooltipItem: VFGTooltipItem, tooltipNumber: Int, numberOfTooltips: Int) {
        titleLabel.text = tooltipItem.title
        titleLabel.textAlignment = .natural
        descriptionLabel.text = tooltipItem.description
        button.setTitle(tooltipItem.button.title, for: .normal)
        dismissAllButton.setTitle(tooltipItem.dismissAllButtonTitle, for: .normal)
        onButtonPress = tooltipItem.button.onPress
        counterLabel.text = "\(tooltipNumber)/\(numberOfTooltips)"
        setupAccessibilityIDs()
        setupVoiceOverAccessibility(tooltipItem, tooltipNumber, numberOfTooltips)
    }

    func setupAccessibilityIDs() {
        let buttonText = button.titleLabel?.text?.lowercased() ?? ""
        titleLabel.accessibilityIdentifier = "TVtitleLabel"
        descriptionLabel.accessibilityIdentifier = "TVdescriptionLabel"
        counterLabel.accessibilityIdentifier = "TVcounterLabel"
        button.accessibilityIdentifier = "TV\(buttonText)Button"
        dismissAllButton.accessibilityIdentifier = "TVdismissButton"
    }

    func setupVoiceOverAccessibility(_ tooltipItem: VFGTooltipItem, _ tooltipNumber: Int, _ numberOfTooltips: Int) {
        titleLabel.accessibilityLabel = tooltipItem.title
        descriptionLabel.accessibilityLabel = tooltipItem.description
        counterLabel.accessibilityLabel = "\(VFGDateHelper.daySuffix(day: tooltipNumber)) of \(numberOfTooltips) cards"
        button.accessibilityLabel = tooltipItem.button.title
        accessibilityCustomActions = [nextButtonVoiceOverAction()]
        if !dismissAllButton.isHidden {
            dismissAllButton.accessibilityLabel = tooltipItem.dismissAllButtonTitle
            accessibilityCustomActions = [
                nextButtonVoiceOverAction(),
                dismissAllButtonVoiceOverAction()
            ]
        }
    }

    @IBAction func buttonDidPress() {
        onDismiss?()
        onButtonPress?()
    }

    @IBAction func dismissAllDidPress() {
        onDismissAll?()
    }

    func nextButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = button.titleLabel?.text ?? "next"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(buttonDidPress))
    }

    func dismissAllButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = dismissAllButton.titleLabel?.text ?? "dismiss all"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(dismissAllDidPress))
    }
}
