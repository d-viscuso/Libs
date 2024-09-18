//
//  VFGEditAccountLoadingState.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 21/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie

class VFGUpdateAccountLoadingView: UIView {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: VFGLabel!

    func setup(title: String? = nil) {
        animationView.animation = Animation.vodafoneLogo
        animationView.play()
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        titleLabel.text = title
    }
}

extension VFGUpdateAccountLoadingView: VFQuickActionsModel {
    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
    }

    func closeQuickAction() {
    }

    var quickActionsContentView: UIView {
        self
    }

    var quickActionsTitle: String {
        ""
    }

    var isCloseButtonHidden: Bool {
        true
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
