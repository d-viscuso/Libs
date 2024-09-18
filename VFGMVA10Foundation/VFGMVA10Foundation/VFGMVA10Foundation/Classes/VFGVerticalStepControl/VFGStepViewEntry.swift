//
//  VFGStepViewEntry.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Mahmoud Zaki on 6/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit

/// The protocol to which each step must implicitly conform to.
/// - Parameters:
///   - stepEntryDelegate: VFGStepViewEntryDelegate in which used to pass step, action and data
///   - title: step title
///   - stepView: view to display for the step
///   - data: optional dictionary for the configration for each step for example it may contains (title, description, imageName, accessibilityIdInitial)
///   - sideView: optional side view
///   - init: initializer to pass configuration dictionary for example (title, description, imageName, accessibilityIdInitial)
public protocol VFGStepViewEntry: AnyObject {
    var stepEntryDelegate: VFGStepViewEntryDelegate? { get set }
    var title: String? { get set }
    var stepView: UIView { get }
    var data: [String: Any]? { get set }
    var sideView: UIView? { get set }
    init(config: [String: Any]?)
}

extension VFGStepViewEntry {
    public var data: [String: Any]? { nil }
    public var sideView: UIView? { nil }
}

/// Step view entry Delegate 
public protocol VFGStepViewEntryDelegate: AnyObject {
    /// Implementation for presenting the step
    /// - Parameters:
    ///   - stepEntry: VFGStepViewEntry in which used to pass step view
    ///   - action: action that taks in ervery step
    ///   - data: dictionary for the configration for each step for example it may contains (title, description, imageName, accessibilityIdInitial)
    func stepEntry(_ stepEntry: VFGStepViewEntry?, action: VFGStepAction, data: [String: Any]?)
}
