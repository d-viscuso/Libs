//
//  UAirship+Notification.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 10/4/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
public extension Notification.Name {
    static let VFGAppLaunchedFromInboxPush = Notification.Name("UAirshipLaunchedFromInboxPush")

    // Permission notifications
    static let LocationPermissionChanged = Notification.Name("LocationPermissionChanged")
    static let ContactPermissionChanged = Notification.Name("ContactPermissionChanged")
    static let NetworkPermissionChanged = Notification.Name("NetworkPermissionChanged")
    static let PersonalizedNetworkPermissionChanged = Notification.Name("PersonalizedNetworkPermissionChanged")
    static let PushNotificationPermissionChanged = Notification.Name("PushNotificationPermissionChanged")
}
