//
//  CoreState.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 10/06/2019.
//  Copyright © 2019 Mobica. All rights reserved.
//

import Foundation

/// Core state.
open class CoreState: AppStateDelegate {
    open var start: Date?

    open var stateManager: StateManager? {
        return VFGManagerFramework.stateDelegate?.stateManager
    }

    open var name: String {
        return String(describing: self)
    }

    open func isValidNextState(_ stateClass: AppStateDelegate.Type) -> Bool {
        return stateClass == BackgroundState.self
    }

    open func didEnterWithPreviousState(_ previous: AppStateDelegate?) {
        start = Date()
    }

    open func willExitWithNextState(_ next: AppStateDelegate) {
    }

    public init() {
    }
}
