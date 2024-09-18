//
//  VFGActiveAutoTopUpModel.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 22/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public class VFGActiveAutoTopUpModel: VFGActiveAutoTopUpProtocol {
    public var autoTopUpType: String
    public var exactOccurrence: String
    public var autoTopUpAmount: Double
    public var paymentCard: PaymentModelProtocol
    init(
        autoTopUpType: String,
        exactOccurrence: String,
        autoTopUpAmount: Double,
        paymentCard: PaymentModelProtocol
    ) {
        self.autoTopUpType = autoTopUpType
        self.exactOccurrence = exactOccurrence
        self.autoTopUpAmount = autoTopUpAmount
        self.paymentCard = paymentCard
    }
}

/// Active auto topUp model protocol.
public protocol VFGActiveAutoTopUpProtocol {
    /// Selected auto topUp type if weekly, monthly or amount.
    var autoTopUpType: String { get }
    /// Selected exact occurrence weither day or minmum amount.
    var exactOccurrence: String { get }
    /// Selected auto topUp amount.
    var autoTopUpAmount: Double { get }
    /// Selected payment card.
    var paymentCard: PaymentModelProtocol { get }
}
