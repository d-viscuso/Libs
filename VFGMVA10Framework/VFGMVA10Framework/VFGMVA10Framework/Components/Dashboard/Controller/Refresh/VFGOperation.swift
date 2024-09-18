//
//  VFGOperation.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 11/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
/// Dashboard operations handler
class VFGOperation: Operation {
    /// List of operation states
    enum State: String {
        case isReady
        case isExecuting
        case isFinished
    }
    /// Operation current state
    var state: State = .isReady {
        willSet(newValue) {
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }

    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { state == .isExecuting }
    override var isFinished: Bool {
        if isCancelled && state != .isExecuting { return true }
        return state == .isFinished
    }
}
