//
//  VFGCountdownDelegate.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 19/06/2022.
//

import Foundation

public protocol VFGCountdownDelegate: AnyObject {
    /// Notify the delegate once the countdown state changed.
    /// - Parameters:
    ///   - view: Current countdown view associated with the delegate.
    ///   - state: Chnaged state.
    func countdown(_ view: VFGCountdownView, stateDidChange state: VFGTimerState)
    /// Notify the delegate once an amount of time between two given points in time is changed.
    /// - Parameters:
    ///   - view: Current countdown view associated with the delegate.
    ///   - time: Changed time interval.
    func countdown(_ view: VFGCountdownView, countdownTimeDidChange time: TimeInterval)
}

extension VFGCountdownDelegate {
    public func countdown(_ view: VFGCountdownView, stateDidChange state: VFGTimerState) {}
    public func countdown(_ view: VFGCountdownView, countdownTimeDidChange time: TimeInterval) {}
}
