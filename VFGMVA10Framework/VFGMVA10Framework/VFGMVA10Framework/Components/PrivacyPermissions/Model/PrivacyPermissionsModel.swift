//
//  PrivacyPermissionsModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Privacy Permissions Model
public struct PrivacyPermissionsModel: Codable {
    /// Privacy Overlay Model
    public var privacyPermissionsOverlay: PrivacyPermissionsOverlay
    /// Privacy Permissions Settings Model 
    public var privacyPermissionsSettings: PrivacyPermissionsSettings
    /// Privacy Policy Overlay Model
    public var privacyPolicyOverlay: PrivacyPolicyOverlay

    // MARK: - PrivacyPermissionsOverlay
    public struct PrivacyPermissionsOverlay: Codable {
        var infoSection: InfoSection
        var benefits: [Benefit]

        // MARK: - Benefit
        public struct Benefit: Codable {
            var image: String
            var imageDesc: String
            var title: String
        }

        // MARK: - InfoSection
        public struct InfoSection: Codable {
            var title, briefHTMLDesc: String
            var fullHTMLDesc: String?
        }
    }

    // MARK: - PrivacyPermissionsSettings
    public struct PrivacyPermissionsSettings: Codable {
        var infoSection: [InfoSection]
        var permissionProfiles: [PermissionProfile]
        var contactPreferences: [InfoSection]
        var preferredContacts: PreferredContacts

        // MARK: - InfoSection
        public struct InfoSection: Codable {
            var title, briefHTMLDesc: String
            var fullHTMLDesc: String?
        }

        // MARK: - PermissionProfile
        public struct PermissionProfile: Codable {
            var profileID, title, subtitle, image: String
            var toggleState: Bool
        }

        // MARK: - PreferredContacts
        public struct PreferredContacts: Codable {
            var title: String
            var contacts: [Contact]
            // MARK: - Contact
            public struct Contact: Codable {
                var contactID, title: String
                var toggleState: Bool
            }
        }
    }
    // MARK: - PrivacyPolicyOverlay
    public struct PrivacyPolicyOverlay: Codable {
        var headerTitle: String?
        var title: String?
        var fullHTMLDesc: String?
    }
}
