//
//  VFGPermissionType.swift
//  VFGFoundation
//
//  Created by Hussien Gamal Mohammed on 6/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public enum VFGPermissionType: Equatable {
    case locationAlways
    case locationWhileUsage
    case network
    case pushNotifications
    case contacts
    case custom(type: String)

    init?(rawValue: String) {
        switch rawValue {
        case "locationAlways": self = .locationAlways
        case "locationWhileUsage", "location": self = .locationWhileUsage
        case "network": self = .network
        case "pushNotifications": self = .pushNotifications
        case "contacts": self = .contacts
        default: return nil
        }
    }

    public static func == (lhs: VFGPermissionType, rhs: VFGPermissionType) -> Bool {
        switch (lhs, rhs) {
        case let (.custom(lhsString), .custom(rhsString)):
            return lhsString == rhsString
        case (.locationAlways, .locationAlways): return true
        case (.locationWhileUsage, .locationWhileUsage): return true
        case (.network, .network): return true
        case (.pushNotifications, .pushNotifications): return true
        case (.contacts, .contacts): return true
        default:
            return false
        }
    }
}

enum VFGPermissionTypeAccessibilityIdentifier {
    static func getPermissionCardId(type: VFGPermissionType) -> String {
        switch type {
        case .locationAlways:
            return "OBpermissionLocation"
        case .locationWhileUsage:
            return "OBpermissionLocation"
        case .network:
            return "OBpermissionNetwork"
        case .pushNotifications:
            return "OBpermissionNotifications"
        case .contacts:
            return "OBpermissionCalls"
        case .custom(let type):
            return "OBpermission\(type)"
        }
    }
}
