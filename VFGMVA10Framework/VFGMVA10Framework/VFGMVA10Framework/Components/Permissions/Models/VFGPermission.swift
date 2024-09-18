//
//  VFGPermission.swift
//  VFGMVA10Group
//
//  Created by Mohamed Sayed on 7/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// VFGPermission model.
public struct VFGPermission: Equatable {
    /// Permission type.
    public var type: VFGPermissionType
    /// Permission state if true or false, default is true.
    public var defaultStatus = true
    /// Permission title.
    public var title: String
    /// Permission description.
    public var description: String
    /// Permission icon name in assets.
    public var icon: UIImage
    /// List of permissions dependent on current permission. Will be hidden if the current permission state is false.
    public var dependents: [VFGPermission] = []

    public init(
        permissionType: VFGPermissionType,
        defaultStatus: Bool = true,
        title: String,
        description: String,
        icon: UIImage,
        dependents: [VFGPermission] = []
    ) {
        self.defaultStatus = defaultStatus
        self.dependents = dependents
        self.description = description
        self.title = title
        self.type = permissionType
        self.icon = icon
    }

    public static func == (lhs: VFGPermission, rhs: VFGPermission) -> Bool {
        return lhs.type == rhs.type &&
            lhs.title == rhs.title &&
            lhs.icon == rhs.icon
    }
}

public enum VFGAllPermissions {
    static func permission(type: VFGPermissionType, dependents: [VFGPermission] = []) -> VFGPermission {
        var title = ""
        var description = ""
        var icon: UIImage?
        switch type {
        case .locationWhileUsage, .locationAlways:
            title = "permissions_location_title"
            description = "permissions_location_description"
            icon = VFGFrameworkAsset.Image.icLocation
        case .network:
            title = "improving_our_network_title"
            description = "permissions_network_description"
            icon = VFGFrameworkAsset.Image.icNetworkMap
        case .pushNotifications:
            title = "permissions_push_notifications_title"
            description = "permissions_push_notifications_description"
            icon = UIImage.VFGNotification
        case .contacts:
            title = "permissions_contact_title"
            description = "permissions_contact_description"
            icon = VFGFrameworkAsset.Image.icCallsContacts
        case .custom:
            break
        }

        return VFGPermission(
            permissionType: type,
            title: title.localized(bundle: .mva10Framework),
            description: description.localized(bundle: .mva10Framework),
            icon: icon ?? UIImage(),
            dependents: dependents)
    }
}

public enum VFGAppPrivacyPermissions {
    public static let personalizedNetwork = VFGPermission(
        permissionType: .custom(type: "VFGPersonalizedNetworkPermission"),
        title: "permissions_app_personalised_title"
            .localized(bundle: Bundle.mva10Framework),
        description: "permissions_app_personalised_description"
            .localized(bundle: Bundle.mva10Framework),
        icon: VFGFrameworkAsset.Image.icUsers ?? UIImage())

    public static let network = VFGPermission(
        permissionType: .network,
        title: "improving_our_network_title"
            .localized(bundle: Bundle.mva10Framework),
        description: "improving_our_network_description"
            .localized(bundle: Bundle.mva10Framework),
        icon: VFGFrameworkAsset.Image.icNetworkMap ?? UIImage(),
        dependents: [VFGAppPrivacyPermissions.personalizedNetwork])
}
