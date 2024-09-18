//
//  AutoTopUpModel.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 05/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Auto topUp model protocol.
public protocol AutoTopUpModelProtocol {
    // A variable to move the position of the currency icon from left to right or from right to left
    var isIconRTL: Bool { get }

    // Array of amounts that user can choose to auto top-up when the balance get below the selected amount
    var amounts: [Int] { get }

    // A variable that represents the currency of paying. ex)$, €
    var currency: String { get }
}
