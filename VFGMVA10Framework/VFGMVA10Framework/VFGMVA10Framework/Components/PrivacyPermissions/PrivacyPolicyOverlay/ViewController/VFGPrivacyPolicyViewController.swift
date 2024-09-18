//
//  VFGPrivacyPolicyViewController.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 07/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGPrivacyPolicyViewController: UIViewController {
    @IBOutlet weak var backButton: VFGButton!
    @IBOutlet weak var headerTitleLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var htmlTextView: UITextView!
    @IBOutlet weak var htmlTextViewHeightConstraint: NSLayoutConstraint!

    /// Privacy permissions settings model
    var model = VFGPrivacyPermissionsManager.model?.privacyPolicyOverlay

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(VFGFrameworkAsset.Image.icArrowLeft, for: .normal)
        headerTitleLabel.text = model?.headerTitle
        titleLabel.text = model?.title
        setupTextView(text: model?.fullHTMLDesc ?? "")
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        backButton.accessibilityLabel = "Back"
        headerTitleLabel.accessibilityLabel = headerTitleLabel.text ?? ""
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        htmlTextView.accessibilityLabel = htmlTextView.text ?? ""
        accessibilityCustomActions = [backButtonVoiceOverAction()]
    }

    @IBAction func backButtonDidPressed(_ sender: Any) {
        backButtonPressed()
    }
    @objc func backButtonPressed() {
        if let privacyPermissionVC = self.parent as? VFGPrivacyPermissionViewController {
            privacyPermissionVC.outerStackView.isHidden = false
            privacyPermissionVC.setupAccessibilityCustomActions()
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    func backButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Back"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(backButtonPressed))
    }
}

extension VFGPrivacyPolicyViewController {
    /// Method that is used to setup views
    ///  - Parameters:
    ///     - text: description of privacy permission
    ///     - fontSize: font size for description of privacy permission
    ///     - fontColor: font color for description of privacy permission
    func setupTextView(
        text: String,
        fontSize: CGFloat = 16.6,
        fontColor: UIColor = .VFGPrimaryText
    ) {
        htmlTextView.isUserInteractionEnabled = false
        htmlTextView.isScrollEnabled = true
        htmlTextView.attributedText = text.attributedTextFrom(
            htmlText: text,
            fontSize: fontSize,
            color: fontColor)
        htmlTextViewHeightConstraint.constant = htmlTextView.contentSize.height
        htmlTextView.backgroundColor = .clear
        htmlTextView.isScrollEnabled = false
    }
}
