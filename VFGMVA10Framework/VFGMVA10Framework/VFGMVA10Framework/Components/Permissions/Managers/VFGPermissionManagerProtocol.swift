//
//  VFGPermissionManagerProtocol.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 8/24/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// Permission manager protocol.
public protocol VFGPermissionManagerProtocol {
    /// Request current state for list of permissions.
    /// - Parameters:
    ///     - types: List of the required permissions of type *VFGPermissionType*.
    ///     - completionBlock: *PermissionsCallback* is a typealias for *(PermissionResult, Error?) -> Void*.
    func requestPermissions(
        types: [VFGPermissionType],
        _ completionBlock: @escaping PermissionsCallback
    )
    /// Request current state for a single permission.
    /// - Parameters:
    ///     - type: The required permission.
    ///     - completionBlock: *PermissionCallback* is a typealias for *(VFGPermissionStatus, Error?) -> Void*.
    func requestPermission(
        type: VFGPermissionType,
        _ completionBlock: @escaping PermissionCallback
    )
    /// Set a list of permissions with same status.
    /// - Parameters:
    ///     - types: List of the required permissions of type *VFGPermissionType*.
    ///     - status: Status you want to set the list of permissions if true or false.
    ///     - info: Dictionary of *[String: Any]?* .
    ///     - completionBlock: *PermissionCallback* is a typealias for *(VFGPermissionStatus, Error?) -> Void*.
    func setPermissions(
        types: [VFGPermissionType],
        status: Bool,
        info: [String: Any]?,
        _ completionBlock: @escaping PermissionCallback
    )
    /// Set a single permission with same status.
    /// - Parameters:
    ///     - types: List of the required permissions of type *VFGPermissionType*.
    ///     - status: Status you want to set the list of permissions if true or false.
    ///     - info: Dictionary of *[String: Any]?* .
    ///     - completionBlock: *PermissionCallback* is a typealias for *(VFGPermissionStatus, Error?) -> Void*.
    func setPermission(
        type: VFGPermissionType,
        status: Bool,
        info: [String: Any]?,
        _ completionBlock: @escaping PermissionCallback
    )
    /// Check the status for the wanted permission and provide it via *completionBlock* if allowed, denied or notDetermined.
    /// - Parameters:
    ///     - type: Permission type.
    ///     - completionBlock: *PermissionCallback* is a typealias for *(VFGPermissionStatus, Error?) -> Void*.
    func permissionStatus(type: VFGPermissionType, _ completionBlock: @escaping PermissionCallback)
}
