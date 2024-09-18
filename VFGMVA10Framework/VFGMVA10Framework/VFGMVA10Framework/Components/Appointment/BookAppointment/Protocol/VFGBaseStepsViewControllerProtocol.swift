//
//  VFGBaseStepsViewControllerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Base steps view controller protocol.
public protocol VFGBaseStepsViewControllerProtocol: UIViewController {
    /// Fetch required data for current step.
    func fetchData()
    /// Step title.
    var stepTitle: String { get }
    /// Completion that will be called when the step is completed.
    var onStepComplete: ((Any) -> Void)? { get set }
    /// Completion with the new step view height when it changes to update it's container view controller.
    var onContentHeightChange: ((_ difference: CGFloat) -> Void)? { get set }
}

extension VFGBaseStepsViewControllerProtocol {
    func fetchData() {}
}
