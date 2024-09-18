//
//  VFGSetPrivacyPermissionsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 27/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Set privacy permissions Model
class VFGSetPrivacyPermissionsViewModel {
    /// Info section for setting privacy permission
    var infoSection: [VFGPrivacyPermissionsInfoCellUIModel]?
    /// Permission Profiles
    var permissionProfiles: [VFGProfilePrivacyPermissionCellUIModel]?
    /// Contact profiles that is used in setting privacy permissions
    var contactPreferences: [VFGPrivacyPermissionsInfoCellUIModel]?
    /// Contacts that is used in setting privacy permissions
    var contacts: [VFGContactPrivacyPermissionCellUIModel]?
    /// Title for preferred contact  section
    var preferredContactsSectionTitle: String?

    init(model: PrivacyPermissionsModel.PrivacyPermissionsSettings) {
        infoSection = model.infoSection.map {
            return VFGPrivacyPermissionsInfoCellUIModel(infoSection: $0)
        }

        permissionProfiles = model.permissionProfiles.map {
            return VFGProfilePrivacyPermissionCellUIModel(permissionProfile: $0)
        }

        contactPreferences = model.contactPreferences.map {
            return VFGPrivacyPermissionsInfoCellUIModel(infoSection: $0)
        }

        contacts = model.preferredContacts.contacts.map {
            return VFGContactPrivacyPermissionCellUIModel(contact: $0)
        }

        preferredContactsSectionTitle = model.preferredContacts.title
    }

    func getPrivacyPermissions() -> (profilePermissions: [PrivacyPermissionsModel.PrivacyPermissionsSettings.PermissionProfile]?, preferredContacts: [PrivacyPermissionsModel.PrivacyPermissionsSettings.PreferredContacts.Contact]?) {
        let profilePermissions = self.permissionProfiles?.map { $0.permissionProfile }
        let contacts = self.contacts?.map { return $0.contact }
        return (profilePermissions, contacts)
    }
    /// Method that is used to setup state of each section in setting privacy permission
    ///  - Parameters:
    ///     - indexPath: indexPath for section that is needed to configure
    ///  - Returns:
    ///     - state: toggle state
    ///     - shouldReloadSection: Boolean to indicate should reload section or not
    func toggleState(with indexPath: IndexPath?) -> (state: Bool?, shouldReloadSection: Bool) {
        guard let indexPath = indexPath else { return (nil, false) }
        switch indexPath.section {
        case 1:
            return handleProfileSettingsToggleState(with: indexPath)
        case 3:
            contacts?[indexPath.row].contact.toggleState.toggle()
            return (contacts?[indexPath.row].contact.toggleState, false)
        default:
            return (nil, false)
        }
    }
    /// Method that is used to setup state of profile settings section
    ///  - Parameters:
    ///     - indexPath: indexPath for profile setting row
    ///  - Returns:
    ///     - state: toggle state
    ///     - shouldReloadSection: Boolean to indicate should reload row or not

    private func handleProfileSettingsToggleState(with indexPath: IndexPath) -> (state: Bool?, shouldReloadSection: Bool) {
        switch indexPath.row {
        case 0: // Basic
            if permissionProfiles?[indexPath.row].permissionProfile.toggleState ?? false {
                permissionProfiles?[indexPath.row].permissionProfile.toggleState = false
                if indexPath.row + 1 < (permissionProfiles?.count ?? 0),
                    permissionProfiles?[indexPath.row + 1].permissionProfile.toggleState == true {
                    permissionProfiles?[indexPath.row + 1].permissionProfile.toggleState = false
                    return (nil, true)
                }
                return (permissionProfiles?[indexPath.row].permissionProfile.toggleState, false)
            } else {
                permissionProfiles?[indexPath.row].permissionProfile.toggleState.toggle()
                return (permissionProfiles?[indexPath.row].permissionProfile.toggleState, false)
            }
        case 1: // Advanced
            if permissionProfiles?[indexPath.row].permissionProfile.toggleState == false {
                permissionProfiles?[indexPath.row].permissionProfile.toggleState = true
                if permissionProfiles?[indexPath.row - 1].permissionProfile.toggleState == true {
                    return (permissionProfiles?[indexPath.row].permissionProfile.toggleState, false)
                } else {
                    permissionProfiles?[indexPath.row - 1].permissionProfile.toggleState.toggle()
                }
                return (nil, true)
            } else {
                permissionProfiles?[indexPath.row].permissionProfile.toggleState.toggle()
                return (permissionProfiles?[indexPath.row].permissionProfile.toggleState, false)
            }
        default:
            return (nil, false)
        }
    }
}

struct VFGPrivacyPermissionsInfoCellUIModel {
    var infoSection: PrivacyPermissionsModel.PrivacyPermissionsSettings.InfoSection
    var isExpanded = false
    init(infoSection: PrivacyPermissionsModel.PrivacyPermissionsSettings.InfoSection) {
        self.infoSection = infoSection
    }
}

struct VFGProfilePrivacyPermissionCellUIModel {
    var permissionProfile: PrivacyPermissionsModel.PrivacyPermissionsSettings.PermissionProfile
}

struct VFGContactPrivacyPermissionCellUIModel {
    var contact: PrivacyPermissionsModel.PrivacyPermissionsSettings.PreferredContacts.Contact
}
