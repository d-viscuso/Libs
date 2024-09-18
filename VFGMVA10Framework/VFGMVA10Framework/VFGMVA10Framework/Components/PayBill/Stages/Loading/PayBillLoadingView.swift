//
//  PayBillLoadingView.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
import Lottie

class PayBillLoadingView: UIView {
    @IBOutlet weak var loadingLabel: VFGLabel!
    @IBOutlet weak var animationView: AnimationView!
    weak var delegate: VFGPayBillStateInternalProtocol?

    func configure(viewModel: PayBillLoadingViewModel) {
        animationView.animation = Animation.vodafoneLogo
        animationView.play()
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        loadingLabel.text = viewModel.loadingTitle
        loadingLabel.accessibilityIdentifier = "PBloadingText"
        animationView.accessibilityIdentifier = "PBloadingLogo"
        animationView.accessibilityLabel = "Vodafone logo loading animated view"
        loadingLabel.accessibilityLabel = loadingLabel.text ?? ""
    }
}
