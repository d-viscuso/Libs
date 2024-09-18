//
//  VFGSuccessAddPlanView.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import Lottie
import VFGMVA10Foundation

class VFGSuccessAddPlanView: UIView {
    @IBOutlet weak var returnToMyPlanButton: VFGButton!
    @IBOutlet weak var successMainLabel: VFGLabel!
    @IBOutlet weak var successSubtitleLabel: VFGLabel!
    @IBOutlet weak var animationView: AnimationView!

    weak var delegate: VFGAddPlanStateInternalProtocol?

    func configure(with viewModel: VFGSuccessAddPlanViewModel) {
        animationView.animation = Animation.tick
        animationView.play()
        successMainLabel.text = viewModel.sectionTitle
        successMainLabel.textColor = .primaryTextColor
        successSubtitleLabel.text = viewModel.subTitle
        successSubtitleLabel.textColor = .primaryTextColor
        returnToMyPlanButton.setTitle(viewModel.buttonTitle, for: .normal)
        returnToMyPlanButton.accessibilityIdentifier = "TP\(viewModel.buttonTitle.lowercased())Button"
        setupAccessibilityLabels()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle
        else { return }
        animationView.animation = Animation.tick
        animationView.currentProgress = 1
    }

    @IBAction func returnToMyPlanTapped(_ sender: Any) {
        delegate?.successViewFinished()
    }

    private func setupAccessibilityLabels() {
        animationView.isAccessibilityElement = false
    }
}
