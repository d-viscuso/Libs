//
//  VFGHorizontalStepControlDelegate.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// A delegate protocol that manages user interactions with the horizontal step control,
/// including complete, return to, skip, did add and did move to step
public protocol VFGHorizontalStepControlDelegate: NSObjectProtocol {
    /// Notify the delegate once the step is completed.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the completed step.
    func stepControl(_ stepControl: VFGHorizontalStepControl, didCompleteStepAt index: Int)
    /// Notify the delegate once return to a step at specific index.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you returned back to.
    func stepControl(_ stepControl: VFGHorizontalStepControl, didReturnToStepAt index: Int)
    /// Notify the delegate once skip a step at specific index.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you skipped.
    func stepControl(_ stepControl: VFGHorizontalStepControl, didSkipStepAt index: Int)
    /// Notify the delegate once add a step at specific index.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you added.
    func stepControl(_ stepControl: VFGHorizontalStepControl, didAddStepAt index: Int)
    /// Notify the delegate once move to a step at specific index.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you moved to.
    func stepControl(_ stepControl: VFGHorizontalStepControl, didMoveToStepAt index: Int)
}

public extension VFGHorizontalStepControlDelegate {
    func stepControl(_ stepControl: VFGHorizontalStepControl, didSkipStepAt index: Int) { }
    func stepControl(_ stepControl: VFGHorizontalStepControl, didAddStepAt index: Int) { }
    func stepControl(_ stepControl: VFGHorizontalStepControl, didMoveToStepAt index: Int) { }
}
