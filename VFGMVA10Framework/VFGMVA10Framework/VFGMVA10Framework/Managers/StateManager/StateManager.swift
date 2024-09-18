//
//  StateManager.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 10/06/2019.
//  Copyright © 2019 Mobica. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/**
Logical state machine
*/
open class StateManager {
    private var states: [AppStateDelegate]
    private let queue: OperationQueue

    /**
    Returns current state of machine
    */
    public weak var currentState: AppStateDelegate?

    /**
    Initializer
    - Parameter states: allowed states for state machine
    - Returns: initialized state machine
    */
    public init(states: [AppStateDelegate]?) {
        self.queue = OperationQueue.main
        self.states = states ?? [AppStateDelegate]()
    }

    /**
    Check if specific state is allowed
    - Parameter stateClass: state which is being checked
    - Returns: true if machine can enter state otherwise false
    */
    func canEnter(_ stateClass: AppStateDelegate.Type) -> Bool {
        var canEnterState = false
        guard let currentState = currentState else {
            return false
        }
        if currentState.isValidNextState(stateClass) {
            canEnterState = true
        } else {
            VFGErrorLog("\(currentState.name) --> \(state(with: stateClass)?.name ?? "[]") not allowed")
        }
        return canEnterState
    }

    /**
    Returns state object for specific state class
    - Parameter stateClass: class of state
    - Returns: initialized state object for specified class
    */
    func state(with stateClass: AppStateDelegate.Type?) -> AppStateDelegate? {
        guard let stateClass = stateClass else { return nil }
        for state in states where String(describing: state).hasSuffix(String(describing: stateClass)) {
            return state
        }
        VFGErrorLog("State: \(stateClass) isn't initialized")
        return nil
    }

    /**
    Move to specific state
    - Parameter stateClass: state class
    - Parameter completion: optional completion block
    */
    open func moveTo(_ stateClass: AppStateDelegate.Type?, completion: ((Bool) -> Void)? = nil) {
        guard let stateClass = stateClass,
            let nextState = state(with: stateClass) else {
            VFGErrorLog("Unable to jump to nil")
            finish(false, completion: completion)
            return
        }
        queue.addOperation { [weak self] in
            guard let self = self else { return }
            let previous = self.currentState
            if let previousState = previous {
                if !previousState.isValidNextState(stateClass) {
                    VFGErrorLog("current\(previousState.name) doesn't allow \(nextState.name)")
                    self.finish(false, completion: completion)
                    return
                }
                previousState.willExitWithNextState(nextState)
                let elapsedMilliseconds = String(format: "%.3fms", previousState.start?.elapsedMilliseconds ?? 0)
                VFGDebugLog("<-- state:\(previousState.name) \(elapsedMilliseconds)")
            }

            self.currentState = nextState
            VFGDebugLog("--> state:\(nextState.name)")
            self.currentState?.didEnterWithPreviousState(previous)
            self.finish(true, completion: completion)
        }
    }

    /**
    Ask StateManager to get current state synchronously
    - Parameter completion: block executed when any other previous jumps are completed
    */
    func synchronousState(completion: @escaping ((AppStateDelegate?) -> Void)) {
        queue.addOperation { [weak self] in
            guard let self = self else { return }
            completion(self.currentState)
        }
    }

    // MARK: - Private methods
    private func finish(_ result: Bool, completion: ((Bool) -> Void)?) {
        guard let completion = completion else {
            return
        }
        completion(result)
    }
}
