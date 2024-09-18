//
//  File.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 1/5/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Primary plan service protocol.
public protocol PrimaryPlanServiceProtocol: Codable {
    /// List of additional extra info items.
    var additionalExtraInfo: [PlanExtraInfo]? { get }
    /// List of additional inclusions.
    var additionalInclusions: [AdditionalInclusion]? { get }
    /// List of exta info items.
    var extraInfo: [PlanExtraInfo]? { get }
    /// List of main inclusions.
    var mainInclusions: [MainInclusion]? { get }
    /// Plan name.
    var planName: String? { get }
    /// Plan price unit.
    var planPriceUnit: String? { get }
    /// Plan price.
    var planPrice: String? { get }
    /// Plan status.
    var planStatus: String? { get }
    /// Plan start date.
    var startDate: String? { get }
    /// Plan expiration date.
    var expirationDate: String? { get }
    /// Service title.
    var serviceTitle: String? { get }
    /// Service subtitle.
    var serviceSubtitle: String? { get }
    /// Product start date.
    var productStartDate: String? { get }
    /// Product termination date.
    var productTerminationDate: String? { get }
}
