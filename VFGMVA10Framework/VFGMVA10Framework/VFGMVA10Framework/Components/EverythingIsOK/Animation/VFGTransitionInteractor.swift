//
//  VFGTransitionInteractor.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 11/18/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

class VFGTransitionInteractor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
    var startingPoint: CGFloat = 0
    var startingPaddingPoint: CGFloat = 0
    var currentPaddingPosition: CGFloat = 0

    override init() {
        super.init()
        wantsInteractiveStart = false
    }

    func startTransition(action: () -> Void) {
        if !hasStarted {
            hasStarted = true
            action()
        }
    }

    func cancelTransition(completion: (() -> Void)? = nil) {
        if hasStarted {
            hasStarted = false
            cancel()
            completion?()
        }
    }

    func endTransition(completion: (() -> Void)? = nil) {
        if hasStarted {
            hasStarted = false

            if shouldFinish {
                finish()
            } else {
                cancel()
            }
            completion?()
        }
    }

    func finishTransition(completion: (() -> Void)? = nil) {
        if hasStarted {
            hasStarted = false
            finish()
            completion?()
        }
    }
}
