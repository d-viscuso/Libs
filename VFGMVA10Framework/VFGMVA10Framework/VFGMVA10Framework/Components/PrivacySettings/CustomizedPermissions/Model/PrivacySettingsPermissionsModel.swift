//
//  PrivacySettingsPermissionsModel.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 18/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit

/// Privacy settings permissions model.
public struct PrivacySettingsPermissionsModel: Codable {
    /// List of *InfoSection*.
    var infoSection: [InfoSection]?
    /// Basic permission.
    var basicPermission: PermissionProfile?
    /// List of *PermissionProfile* where the first is the main permission & the rest of the list are subs of the main permission. User can't turn on any sub-permission if the main is off. When you turn the main permission on, all sub-permissions will be turned on. Same when you turn main permission off.
    var advancedPermissions: [PermissionProfile]?
    /// List of *PermissionProfile* that are independent and doesn't affect each  other.
    var singlePermissions: [PermissionProfile]?
}

extension PrivacySettingsPermissionsModel: Equatable {
    public static func == (lhs: PrivacySettingsPermissionsModel, rhs: PrivacySettingsPermissionsModel) -> Bool {
        if lhs.basicPermission?.state != rhs.basicPermission?.state {
            return false
        }

        let advancedCount = rhs.advancedPermissions?.count ?? 0
        for index in 0..<advancedCount where
        rhs.advancedPermissions?[index].state != lhs.advancedPermissions?[index].state {
            return false
        }
        let singlesCount = rhs.singlePermissions?.count ?? 0
        for index in 0..<singlesCount where
        rhs.singlePermissions?[index].state != lhs.singlePermissions?[index].state {
            return false
        }
        return true
    }
}

// MARK: - InfoSection
/// Info section model.
public struct InfoSection: Codable {
    /// Title.
    var title: String?
    /// Brief description in HTML format.
    var briefHTMLDesc: String
    /// Full description in HTML format.
    var fullHTMLDesc: String?
    /// Boolean determines if the field is showing the brief description if false & full description if true. Default is false.
    var isExpanded: Bool? = false
}

// MARK: - PermissionProfile
/// Permission Profile model.
public struct PermissionProfile: Codable {
    /// Permission ID
    var profileID: String
    /// Permission title shown on the cell.
    var title: String
    /// Permission subtitle shown on the cell if exists.
    var subtitle: String?
    /// Icon image name is assets.
    var image: String?
    /// Image description for voice over accessability.
    var imageDescription: String?
    /// Boolean determines if the permission cell will have a toggle button if true or a label if false when the state is permanent and can't be change by the user. Default is true.
    var isToggle: Bool? = true
    /// State of the toggle or label.
    var state: Bool
}
