//
//  VFPermissionCardViewModel.swift
//  VFGMVA10Group
//
//  Created by Mohamed Abd ElNasser on 7/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

/// Permission card view model.
public struct VFPermissionCardViewModel {
    let cardIndex: Int
    let icon: UIImage
    let title: String
    let description: String
    let type: VFGPermissionType
    let defaultStatus: Bool
    let parentIndex: Int?
    var permissionStatus: VFGPermissionStatus?
    var shouldRequestPermission: Bool

    var toggleValueChanged: ((Bool) -> Void)?

    /// Initializer for VFPermissionCardViewModel.
    /// - Parameters:
    ///   - permission: The object of VFGPermission which contains its type, title, etc.
    ///   - permissionStatus: The status of permission which can be one of the following:
    ///     - allowed
    ///     - denied
    ///     - notDetermined
    ///   - cardIndex: The position of the permission in permissions list.
    ///   - parentIndex: The index of parent permission,
    ///     if this permission is depentent it will be shown and hidden depending on parent's status is on or off.
    ///   - shouldRequestPermission: determines when to show permission request pop-up.
    ///     This should happen for enabled and not-determined permissions in the native device settings only.
    public init(
        permission: VFGPermission,
        permissionStatus: VFGPermissionStatus? = nil,
        cardIndex: Int = -1,
        parentIndex: Int? = nil,
        shouldRequestPermission: Bool
    ) {
        self.cardIndex = cardIndex
        self.icon = permission.icon
        self.title = permission.title
        self.description = permission.description
        self.type = permission.type
        self.defaultStatus = permission.defaultStatus
        self.parentIndex = parentIndex
        self.permissionStatus = permissionStatus
        self.shouldRequestPermission = shouldRequestPermission
    }
}
