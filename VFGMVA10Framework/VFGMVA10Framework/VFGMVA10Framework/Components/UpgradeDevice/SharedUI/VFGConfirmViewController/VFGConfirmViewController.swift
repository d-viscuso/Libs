//
//  VFGConfirmViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/12/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Lottie
import VFGMVA10Foundation

class VFGConfirmViewController: UIViewController {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var tickAnimationView: AnimationView!
    @IBOutlet weak var detailsLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var dashboardButton: VFGButton!

    var closeDidTap: (() -> Void)?
    var confirmModel: VFGConfirmModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setAccessibilityForVoiceOver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tickAnimationView.play()
    }

    class func create(confirmModel: VFGConfirmModel) -> VFGConfirmViewController {
        let confirmViewController: VFGConfirmViewController = {
            UIStoryboard(
                name: "VFGConfirmViewController",
                bundle: .mva10Framework
            ).instantiateViewController(withIdentifier: "ConfirmView")
            as? VFGConfirmViewController ?? VFGConfirmViewController()
        }()
        confirmViewController.confirmModel = confirmModel
        return confirmViewController
    }

    func configureUI() {
        titleLabel.text = String(
            format: confirmModel?.title ?? "",
            "Phil")

        subtitleLabel.text = confirmModel?.subtitle
        detailsLabel.text = confirmModel?.details
        tickAnimationView.animation = Animation.tick

        dashboardButton.setTitle(
            confirmModel?.buttonTitle,
            for: .normal
        )
    }

    @IBAction func closeButtonDidPress() {
        closeButtonPressed()
    }

    @objc func closeButtonPressed() {
        closeDidTap?()
        dismiss(animated: false)
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(
                comparedTo: previousTraitCollection
            ) {
                tickAnimationView.animation = Animation.tick
                tickAnimationView.currentProgress = 1
            }
        }
    }
}

// MARK: Voice over
extension VFGConfirmViewController {
    /// Add accessibility for voice over
    func setAccessibilityForVoiceOver() {
        tickAnimationView.accessibilityLabel = "Check mark animated view"
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        detailsLabel.accessibilityLabel = detailsLabel.text ?? ""
        subtitleLabel.accessibilityLabel = subtitleLabel.text ?? ""
        dashboardButton.accessibilityLabel = dashboardButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [closeButtonVoiceOverAction()]
    }

    /// action for close button in voice over
    /// - Returns: action for close button in voice over
    func closeButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = dashboardButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(closeButtonPressed))
    }
}
