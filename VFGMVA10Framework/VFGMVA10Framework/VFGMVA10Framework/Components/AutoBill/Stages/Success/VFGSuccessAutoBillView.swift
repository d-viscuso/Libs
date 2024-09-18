//
//  VFGSuccessAutoBillView.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie
/// Auto bill success state quick action view
class VFGSuccessAutoBillView: UIView {
    @IBOutlet weak var doneButton: VFGButton!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBAction func doneAction(_ sender: Any) {
        doneButtonPressed()
    }
    @objc func doneButtonPressed() {
        delegate?.finishAutoBill()
    }
    func doneVoiceOverAction(with actionName: String) -> UIAccessibilityCustomAction {
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(doneButtonPressed))
    }
    /// An instance of *VFGAutoBillStateInternalProtocol*
    weak var delegate: VFGAutoBillStateInternalProtocol?
    /// *VFGSuccessAutoBillView* configuration
    /// - Parameters:
    ///    - viewModel: *VFGSuccessAutoBillView* view model data
    func configure(with viewModel: VFGSuccessAutoBillViewModel) {
        animationView.animation = Animation.tick
        animationView.play()
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        doneButton.setTitle(viewModel.buttonTitle, for: .normal)
        doneButton.accessibilityIdentifier = "PB\(viewModel.buttonTitle.lowercased())Button"
        setAccessibilityForVoiceOver(with: viewModel)
    }

    func setAccessibilityForVoiceOver(with viewModel: VFGSuccessAutoBillViewModel) {
        animationView.accessibilityLabel = "Check mark animated view"
        titleLabel.accessibilityLabel = viewModel.title
        subtitleLabel.accessibilityLabel = viewModel.subtitle
        doneButton.accessibilityLabel = viewModel.buttonTitle
        accessibilityCustomActions = [doneVoiceOverAction(with: viewModel.buttonTitle)]
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
