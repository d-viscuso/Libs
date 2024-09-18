//
//  VFGAutoTopUpProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 14/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Auto topUp protocol.
public protocol VFGAutoTopUpProtocol: AnyObject {
    /// Auto topUp model.
    var autoTopUpModel: AutoTopUpModelProtocol? { get }
    /// TopUp delegate.
    var topUpDelegate: VFGTopUpProtocol? { get }
    /// Action requesting auto topUp.
    /// - Parameters:
    ///   - activeAutoTopUpModel: *VFGActiveAutoTopUpProtocol* with requested auto topUp data.
    ///   - completion: completion taking boolean as true if the request is success.
    func requestAutoTopUp(
        activeAutoTopUpModel: VFGActiveAutoTopUpProtocol,
        completion: @escaping (
        _ success: Bool?) -> Void
    )
}
