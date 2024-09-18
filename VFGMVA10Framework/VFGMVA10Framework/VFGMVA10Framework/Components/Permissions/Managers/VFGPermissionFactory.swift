//
//  VFGPermissionFactory.swift
//  VFGFoundation
//
//  Created by Hussien Gamal Mohammed on 6/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

class VFGPermissionFactory {
    var bundle: Bundle
    var customPermissions: [VFGPermissionProtocol]
    weak var delegate: VFGNetworkPermissionDelegate?

    func permissionInstance(of type: VFGPermissionType) -> VFGPermissionProtocol? {
        switch type {
        case .locationAlways, .locationWhileUsage:
            return VFGLocationPermission(type, bundle: bundle)
        case .network:
            return VFGNetworkPermission(delegate: delegate)
        case .pushNotifications:
            return VFGPushNotificationsPermission()
        case .contacts:
            return VFGContactsPermission()
        case .custom(let type):
            var permission: VFGPermissionProtocol?
            customPermissions.forEach { customPermission in
                if customPermission.type == type {
                    permission = customPermission
                }
            }
            return permission
        }
    }

    init(
        bundle: Bundle,
        customPermissions: [VFGPermissionProtocol] = [],
        delegate: VFGNetworkPermissionDelegate? = nil
    ) {
        self.bundle = bundle
        self.customPermissions = customPermissions
        self.delegate = delegate
    }
}
