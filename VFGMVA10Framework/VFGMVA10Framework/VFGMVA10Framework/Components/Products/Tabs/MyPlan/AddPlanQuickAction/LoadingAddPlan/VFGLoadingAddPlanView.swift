//
//  VFGLoadingAddPlanView.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import Lottie
import VFGMVA10Foundation

class VFGLoadingAddPlanView: UIView {
    @IBOutlet weak var loadingLabel: VFGLabel!
    @IBOutlet weak var animationView: AnimationView!

    func configure() {
        animationView.animation = Animation.vodafoneLogo
        animationView.play()
        animationView.loopMode = .loop
        loadingLabel.text = "add_data_quick_action_loading".localized(bundle: Bundle.mva10Framework)
        animationView.accessibilityIdentifier = "APanimationView"
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        animationView.animation = Animation.vodafoneLogo
        animationView.play()
        animationView.loopMode = .loop
    }
}
