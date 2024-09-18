//
//  VFGVerticalStepControlDataSource.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 5/9/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// The methods adopted by the object you use to manage user interactions with items in a Tooltips view.
public protocol VFGVerticalStepControlDataSource: NSObjectProtocol {
    /// A method used to return the number of steps for the step control.
    /// - Parameters:
    ///   - stepControl: The vertical step control requesting this information.
    /// - Returns: An integer that represents number of steps.
    func numberOfSteps(_ stepControl: VFGVerticalStepControl) -> Int
    /// A method used to return a step view entry for given step index.
    /// - Parameters:
    ///   - stepControl: The vertical step control requesting this information.
    ///   - index: An index number identifying a step number in step control.
    /// - Returns: An object of type *VFGStepViewEntry*.
    func stepEntry(_ stepControl: VFGVerticalStepControl, at index: Int) -> VFGStepViewEntry?
    /// A method used to return a specific action for given step index.
    /// - Parameters:
    ///   - stepControl: The vertical step control requesting this information.
    ///   - index: An index number identifying a step number in step control.
    /// - Returns: An object of type *VFGStepAction*.
    func savedAction(_ stepControl: VFGVerticalStepControl, forStepAt index: Int) -> VFGStepAction?

    /// A toggle used to enable or disable tap action, default is `true`.
    var enableTapAction: Bool { get }
}

extension VFGVerticalStepControlDataSource {
    public func savedAction(_ stepControl: VFGVerticalStepControl, forStepAt index: Int) -> VFGStepAction? {
        nil
    }

    public var enableTapAction: Bool {
        true
    }
}
