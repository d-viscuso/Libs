//
//  VFGPermissionsTrackingDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 30/11/2021.
//

import VFGMVA10Foundation
public struct VFGPermissionTrackingModel {
    public var event: String
    public var eventSection: String
    public var visitorPermissionFunctional: String
    public var permissionName: String
    public var visitorPermissions: String
}

/// Permission tracking protocol.
public protocol VFGPermissionsTrackingProtocol: AnyObject {
    /// Journey type.
    var journeyType: String { get }
    /// Analytics method to track permissions
    func trackEnabledPermission(
        trackingModel: VFGPermissionTrackingModel
    )
}

public extension VFGPermissionsTrackingProtocol {
    var journeyType: String {
        return ""
    }

    func trackEnabledPermission(
        trackingModel: VFGPermissionTrackingModel
    ) {
        var parameters: [String: String] = [
            VFGAnalyticsKeys.journeyType: journeyType,
            VFGAnalyticsKeys.pageName: journeyType + " " + trackingModel.eventSection,
            VFGAnalyticsKeys.pageSection: journeyType + "; " + trackingModel.eventSection
        ]
        parameters["visitor_permission_functional"] = trackingModel.visitorPermissionFunctional
        parameters["visitor_permission_name"] = trackingModel.permissionName
        parameters["visitor_permission_performance"] = trackingModel.visitorPermissionFunctional
        parameters[
            "visitor_permission_targeting"
        ] = "analytics_framework_visitor_permission_targeting_enabled".localized(bundle: .mva10Framework)
        parameters["visitor_permissions"] = trackingModel.visitorPermissions

        VFGAnalyticsManager.trackView(
            event: trackingModel.event,
            parameters: parameters,
            bundle: .mva10Framework
        )
    }
}
