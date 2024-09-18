//
//  VFGDashboardTopUpModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/17/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// TopUp state.
public enum VFGTopUpState: String, Codable {
    case settled
    case sent
    case new
}

/// Dashboard topUp model protocol.
public protocol VFGDashboardTopUpModelProtocol {
    /// Value of your current balance.
    var value: Double { get }
    /// Unit.
    var unit: String { get }
    /// TopUp state if *settled, sent or new*.
    var topUpState: VFGTopUpState? { get }
    /// Payment due date.
    var paymentDueDate: String? { get }
}

/// Dashboard topUp model.
public struct VFGDashboardTopUpModel: Codable {
    public let value: Double
    public let unit: String
    public let topUpState: VFGTopUpState?
    public let paymentDueDate: String?

    public init(
        value: Double,
        unit: String,
        topUpState: VFGTopUpState?,
        paymentDueDate: String?
    ) {
        self.value = value
        self.unit = unit
        self.topUpState = topUpState
        self.paymentDueDate = paymentDueDate
    }

    public enum CodingKeys: String, CodingKey {
        case value
        case unit
        case paymentDueDate
        case topUpState = "state"
    }
}

extension VFGDashboardTopUpModel: VFGDashboardTopUpModelProtocol {}
