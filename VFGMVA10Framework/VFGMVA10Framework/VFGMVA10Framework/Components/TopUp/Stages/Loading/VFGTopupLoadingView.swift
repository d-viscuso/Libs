//
//  VFGTopupLoadingView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Mahmoud Zaki on 1/15/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
import Lottie

class VFGTopupLoadingView: UIView {
    @IBOutlet weak var loadingLabel: VFGLabel!
    @IBOutlet weak var animationView: AnimationView!
    weak var delegate: VFGTopUpStateInternalProtocol?

    func configure(didPurchaseGift: Bool) {
        animationView.animation = Animation.vodafoneLogo
        animationView.play()
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        loadingLabel.textColor = .VFGRedWhiteText
        loadingLabel.text = didPurchaseGift ?
            "top_up_quick_action_loading_purchase".localized(bundle: Bundle.mva10Framework) :
            "top_up_quick_action_loading_main".localized(bundle: Bundle.mva10Framework)
        loadingLabel.accessibilityIdentifier = "TPloadingText"
        animationView.accessibilityIdentifier = "TPloadingLogo"
        animationView.accessibilityLabel = "Vodafone logo loading animated view"
        loadingLabel.accessibilityLabel = loadingLabel.text ?? ""
    }
}
