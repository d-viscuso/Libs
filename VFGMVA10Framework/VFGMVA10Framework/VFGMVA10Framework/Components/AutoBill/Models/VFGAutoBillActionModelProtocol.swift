//
//  VFGAutoBillActionModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// A protocol for auto bill quick action model
public protocol VFGAutoBillActionModelProtocol {
    /// Default payment card to pay bill
    var defaultPaymentMethod: PaymentModelProtocol? { get set }
    /// Selected day to pay bill
    var selectedDay: Int? { get set }
    /// Date to pay bill
    var billDate: String { get set }
}
