//
//  VFGPermissionProtocol.swift
//  VFGFoundation
//
//  Created by Hussien Gamal Mohammed on 6/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public typealias PermissionCallback = (VFGPermissionStatus, Error?) -> Void

/// Permission protocol.
public protocol VFGPermissionProtocol: AnyObject {
    /// Permission type.
    var type: String { get }

    /// To request status for native permission such as location, push notification, etc.
    /// - Parameters:
    ///     - completionBlock: *PermissionCallback* is a typealias for *(VFGPermissionStatus, Error?) -> Void*.
    func request(_ completionBlock: @escaping PermissionCallback)
    /// To set status for custom permission such as network.
    /// - Parameters:
    ///     - completionBlock: *PermissionCallback* is a typealias for *(VFGPermissionStatus, Error?) -> Void*.
    func set(status: Bool, _ completionBlock: PermissionCallback?, info: [String: Any]?)
    /// Check the status for the wanted permission and provide it via *completionBlock* if allowed, denied or notDetermined.
    /// - Parameters:
    ///     - completionBlock: *PermissionCallback* is a typealias for *(VFGPermissionStatus, Error?) -> Void*.
    func status(_ completionBlock: @escaping PermissionCallback)
    /// Posts the permission status to *NotificationCenter*.
    /// - Parameters:
    ///     - status: Permission status if allowed, denied or notDetermined.
    func notifyObservers(status: VFGPermissionStatus)
}

public extension VFGPermissionProtocol {
    func set(status: Bool, _ completionBlock: PermissionCallback?, info: [String: Any]?) {}
    func notifyObservers(status: VFGPermissionStatus) {}
    func request(_ completionBlock: @escaping PermissionCallback) {}
}
