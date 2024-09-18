//
//  VFGSuccessOverlayViewController.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 10/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
import Lottie

public class VFGSuccessOverlayViewController: UIViewController {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var returnButton: VFGButton!
    @IBOutlet weak var manageButton: VFGButton!

    public weak var navigationDelegate: PrivacyPermissionsNavigationProtocol?
    public var titleKey: String?
    public var descriptionKey: String?
    public var managePrivacyClosure: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.endLoadingAnimation()
        setupUI()
        setAccessibilityForVoiceOver()
    }
    func setupUI() {
        animationView.animation = Animation.tick
        animationView.play()
        titleLabel.text = titleKey?.localized(bundle: .mva10Framework)
        descriptionLabel.text = descriptionKey?.localized(bundle: .mva10Framework)
        returnButton.setTitle(
            "privacy_permissions_dashboard_button"
                .localized(bundle: .mva10Framework),
            for: .normal
        )
        manageButton.setTitle(
            "privacy_permissions_manage_button".localized(bundle: .mva10Framework),
            for: .normal
        )
    }

    func setAccessibilityForVoiceOver() {
        animationView.accessibilityLabel = "Check mark animated view"
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        returnButton.accessibilityLabel = returnButton.titleLabel?.text ?? ""
        manageButton.accessibilityLabel = manageButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [returnToDashboardButtonVoiceOverAction()]
    }

    @IBAction func returnToDashboardDidPressed(_ sender: Any) {
        returnToDashboardButtonPressed()
    }
    @IBAction func managePrivacyDidPressed(_ sender: Any) {
        managePrivacyClosure?()
    }
    @objc func returnToDashboardButtonPressed() {
        navigationDelegate?.closeButtonDidPressed()
    }
    func returnToDashboardButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = returnButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(returnToDashboardButtonPressed)
        )
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(
                comparedTo: previousTraitCollection
            ) {
                animationView.animation = Animation.tick
                animationView.currentProgress = 1
            }
        }
    }
}
