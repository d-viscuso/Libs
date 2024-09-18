//
//  VFPermissionsViewModel + tracking.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 01/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public extension VFPermissionsViewModel {
    func trackPermission(
        _ permissionType: VFGPermissionType,
        for event: String,
        visitorPermissionFunctional: String,
        visitorPermissions: String,
        permissionName: String
    ) {
        trackEnabledPermission(
            event: event,
            eventSection: event,
            visitorPermissionFunctional: visitorPermissionFunctional,
            permissionName: "\(permissionType)",
            visitorPermissions: enabledPermissions()
        )
    }

    func trackEnabledPermission(
        event: String,
        eventSection: String,
        visitorPermissionFunctional: String,
        permissionName: String,
        visitorPermissions: String
    ) {
        let model = VFGPermissionTrackingModel(
            event: event,
            eventSection: eventSection,
            visitorPermissionFunctional: visitorPermissionFunctional,
            permissionName: permissionName,
            visitorPermissions: visitorPermissions
        )
        trackingDelegate?.trackEnabledPermission(trackingModel: model)
    }

    func enabledPermissions() -> String {
        var visitorPermissions = ""
        let lastIndex = permissionCards.count - 1
        for cardIndex in 0...lastIndex where permissionCards[cardIndex].shouldRequestPermission {
            visitorPermissions.append("\(permissionCards[cardIndex].type)")
            if cardIndex != lastIndex {
                visitorPermissions.append(";")
            }
        }
        return visitorPermissions
    }
}
