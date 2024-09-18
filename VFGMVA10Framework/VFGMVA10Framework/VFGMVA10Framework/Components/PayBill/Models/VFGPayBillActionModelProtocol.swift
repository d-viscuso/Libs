//
//  VFGPayBillActionModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGPayBillActionModelProtocol {
    var defaultPaymentMethod: PaymentMethodProtocol? { get }
    var amount: Double { get }
    var currency: String { get }
    var billMonth: String { get }
}
