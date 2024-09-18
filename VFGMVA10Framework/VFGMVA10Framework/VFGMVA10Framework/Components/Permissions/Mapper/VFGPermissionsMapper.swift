//
//  VFGPermissionsMapper.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 16/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
public class VFGPermissionsMapper: VFGPermissionsMapperProtocol {
    public init() {}

    public func createPermissions(from config: [Any]?, with customPermissions: [VFGPermissionProtocol]) -> [VFGPermission] {
        guard let config = config else {
            return [
                VFGAllPermissions.permission(type: .pushNotifications),
                VFGAllPermissions.permission(type: .locationWhileUsage),
                VFGAllPermissions.permission(
                    type: .network,
                    dependents: [VFGAllPermissions.permission(type: .custom(type: "VFGPersonalizedNetworkPermission"))])
            ]
        }
        var permissions: [VFGPermission] = []
        config.forEach {
            let permissionData = $0 as? [String: Any] ?? [:]
            let dependency = permissionData["dependantPermissions"] as? [[String: Any]] ?? [[:]]
            var dependencies: [VFGPermission] = []
            dependency.forEach {
                dependencies.appendIfNotNil(extractPermissions(from: $0, customPermissions: customPermissions))
            }
            permissions.appendIfNotNil(
                extractPermissions(
                    from: permissionData,
                    dependents: dependencies,
                    customPermissions: customPermissions
                )
            )
        }
        return permissions
    }

    private func extractPermissions(
        from data: [String: Any],
        dependents: [VFGPermission] = [],
        customPermissions: [VFGPermissionProtocol]
    ) -> VFGPermission? {
        guard let typeString = data["type"] as? String else { return nil }
        let defaultStatus = (data["defaultStatus"] as? Bool) ?? true
        let customTypes = customPermissions.map { $0.type }
        var permissionType = VFGPermissionType(rawValue: typeString)
        if customTypes.contains(typeString) {
            permissionType = .custom(type: typeString)
        }
        guard let type = permissionType else { return nil }
        return VFGPermission(
            permissionType: type,
            defaultStatus: defaultStatus,
            title: data["title"] as? String ?? "",
            description: data["description"] as? String ?? "",
            icon: VFGImage(named: data["icon"] as? String) ?? UIImage(),
            dependents: dependents)
    }
}
