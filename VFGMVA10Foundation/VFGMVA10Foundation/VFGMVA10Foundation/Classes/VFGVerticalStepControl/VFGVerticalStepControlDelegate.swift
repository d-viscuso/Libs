//
//  VFGVerticalStepControlDelegate.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 5/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// A delegate protocol that manages user interactions with the vertical step control,
/// including complete, return to, skip, did add and did move to step
public protocol VFGVerticalStepControlDelegate: NSObjectProtocol {
    /// Notify the delegate once the step is completed.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the completed step.
    func stepControl(_ stepControl: VFGVerticalStepControl, didCompleteStepAt index: Int)
    /// Notify the delegate once return to a step at specific index.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you returned back to.
    func stepControl(_ stepControl: VFGVerticalStepControl, didReturnToStepAt index: Int)
    /// Notify the delegate once skip a step at specific index.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you skipped.
    func stepControl(_ stepControl: VFGVerticalStepControl, didSkipStepAt index: Int)
    /// Notify the delegate once link at index is pressed..
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the link you pressed.
    func stepControl(_ stepControl: VFGVerticalStepControl, didPressOnLinkAt index: Int)
    /// Notify the delegate once move to a step at specific index.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you moved to.
    func stepControl(_ stepControl: VFGVerticalStepControl, didMoveToStepAt index: Int)
    /// Notify the delegate before moving from a step at specific index.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you moving from.
    func stepControl(_ stepControl: VFGVerticalStepControl, willMoveFromStepAt index: Int)
    /// Notify the delegate once a step at specific index is selected.
    /// - Parameters:
    ///   - stepControl: Current step control associated with the delegate.
    ///   - index: An index that represents the step you selected.
    func stepControl(_ stepControl: VFGVerticalStepControl, didSelectStepAt index: Int)
}

public extension VFGVerticalStepControlDelegate {
    func stepControl(_ stepControl: VFGVerticalStepControl, didCompleteStepAt index: Int) {}
    func stepControl(_ stepControl: VFGVerticalStepControl, didReturnToStepAt index: Int) {}
    func stepControl(_ stepControl: VFGVerticalStepControl, didSkipStepAt index: Int) {}
    func stepControl(_ stepControl: VFGVerticalStepControl, didPressOnLinkAt index: Int) {}
    func stepControl(_ stepControl: VFGVerticalStepControl, didMoveToStepAt index: Int) {}
    func stepControl(_ stepControl: VFGVerticalStepControl, willMoveFromStepAt index: Int) {}
    func stepControl(_ stepControl: VFGVerticalStepControl, didSelectStepAt index: Int) {}
}
