//
//  VFGPermissionManager.swift
//  VFGFoundation
//
//  Created by Hussien Gamal Mohammed on 6/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public typealias PermissionResult = (permissionStatus: VFGPermissionStatus, permissionType: VFGPermissionType)
public typealias PermissionsCallback = (PermissionResult, Error?) -> Void

public class VFGPermissionManager: VFGPermissionManagerProtocol {
    var permissionInstance: VFGPermissionProtocol?
    private let permissionFactory: VFGPermissionFactory
    var permissionInstances: [VFGPermissionProtocol?] = []
    var bundle: Bundle

    public init(
        bundle: Bundle = .main,
        customPermissions: [VFGPermissionProtocol]? = nil,
        delegate: VFGNetworkPermissionDelegate? = nil
    ) {
        self.bundle = bundle
        permissionFactory = VFGPermissionFactory(
            bundle: bundle,
            customPermissions: customPermissions ?? [],
            delegate: delegate)
    }

    public func requestPermissions(
        types: [VFGPermissionType],
        _ completionBlock: @escaping PermissionsCallback
    ) {
        guard let type = types.first else {
            return
        }
        requestPermission(type: type) { [weak self] status, error in
            guard let self = self else { return }
            var newTypes = types
            newTypes.removeFirst()
            completionBlock((status, type), error)
            self.requestPermissions(types: newTypes, completionBlock)
        }
    }

    public func requestPermission(
        type: VFGPermissionType,
        _ completionBlock: @escaping PermissionCallback
    ) {
        guard let instance = permissionFactory.permissionInstance(of: type) else { return }
        permissionInstances.append(instance)
        instance.request(completionBlock)
    }

    public func permissionStatus(type: VFGPermissionType, _ completionBlock: @escaping PermissionCallback) {
        guard let instance = permissionFactory.permissionInstance(of: type) else { return }
        instance.status(completionBlock)
    }

    public func setPermissions(
        types: [VFGPermissionType],
        status: Bool,
        info: [String: Any]?,
        _ completionBlock: @escaping PermissionCallback
    ) {
        for type in types {
            setPermission(type: type, status: status, info: info, completionBlock)
        }
    }

    public func setPermission(
        type: VFGPermissionType,
        status: Bool,
        info: [String: Any]?,
        _ completionBlock: @escaping PermissionCallback
    ) {
        guard let instance = permissionFactory.permissionInstance(of: type) else { return }
        instance.set(status: status, completionBlock, info: info)
    }
}
