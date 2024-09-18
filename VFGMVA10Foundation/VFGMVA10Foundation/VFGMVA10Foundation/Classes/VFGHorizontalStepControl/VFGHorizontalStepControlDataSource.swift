//
//  VFGHorizontalStepControlDataSource.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 8/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// A data source protocol that manages the data in your horizontal step control
/// It represents your data model and vends information to the  horizontal step control as needed
/// It also creates and configures the interaction, number of steps, title, status and steps data URL
/// that the picker view uses to display your data
public protocol VFGHorizontalStepControlDataSource: NSObjectProtocol {
    var isInteractionEnabled: Bool { get }
    /// Return the number of steps for the step control.
    /// - Parameter stepControl: the horizontal step control requesting this information.
    func numberOfSteps(_ stepControl: VFGHorizontalStepControl) -> Int
    /// Provide a title for each step.
    /// - Parameters:
    ///   - stepControl: the horizontal-step-control requesting this information.
    ///   - index: an index number identifying a step number in step control.
    func title(_ stepControl: VFGHorizontalStepControl, forStepAt index: Int) -> String
    /// Provide step status for each step.
    /// - Parameters:
    ///   - stepControl: the horizontal-step-control object requesting this information.
    ///   - index: an index number identifying a step number in step control.
    func status(_ stepControl: VFGHorizontalStepControl, forStepAt index: Int) -> VFGStepStatus
    /// Provide step data.
    /// - Parameter stepControl: the horizontal-step-control object requesting this information.
    func stepsDataURL(_ stepControl: VFGHorizontalStepControl) -> URL?
}

public extension VFGHorizontalStepControlDataSource {
    var isInteractionEnabled: Bool { true }
    func stepsDataURL(_ stepControl: VFGHorizontalStepControl) -> URL? {
        nil
    }

    func status(_ stepControl: VFGHorizontalStepControl, forStepAt index: Int) -> VFGStepStatus {
        .pending
    }
}
