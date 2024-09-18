//
//  PaymentProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 9/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
/// A type alias for the `PaymentDataProviderProtocol` and `AddPaymentProviderProtocol` protocols.
/// it matches any type that conforms to both protocols.
public typealias PaymentProviderProtocol = PaymentDataProviderProtocol & AddPaymentProviderProtocol
