//
//  SubTrayCustomizationManagerDataSource.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Delegation protocol for *SubTrayCustomizationManager* data source
public protocol SubTrayCustomizationManagerDataSource: AnyObject {
    /// Device name text field max length
    var deviceNameMaxLength: Int { get }
    /// Pin code length
    var verificationCodeLength: Int { get }
    /// *SubTrayCustomizationQuickActionsModel* confirmation text
    var defaultNumberConfirmationText: String? { get }
    /// *SubTrayItemVerificationViewController* main title text
    var verificationConfirmationText: String? { get }
}

public extension SubTrayCustomizationManagerDataSource {
    var deviceNameMaxLength: Int { 17 }
    var verificationCodeLength: Int { 6 }
    var defaultNumberConfirmationText: String? { nil }
    var verificationConfirmationText: String? { nil }
}
