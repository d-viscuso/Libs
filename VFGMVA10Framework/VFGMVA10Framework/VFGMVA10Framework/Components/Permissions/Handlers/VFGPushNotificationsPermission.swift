//
//  VFGPushNotificationsPermission.swift
//  VFGMVA10Group
//
//  Created by Mohamed Sayed on 7/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import UserNotifications

public class VFGPushNotificationsPermission: VFGPermissionProtocol {
    public var type: String { "" }

    let pushNotifcationBackgroundMode = "UIBackgroundModes"
    let pushNotifcationRemoteKey = "remote-notification"
    var notificationManager: VFGRemoteNotificationManager

    var notificationOptions: UNAuthorizationOptions = [.sound, .alert, .badge]

    init(notificationManager: VFGRemoteNotificationManager = VFGRemoteNotificationManager.shared) {
        self.notificationManager = notificationManager
    }

    /**
    Requests notifications permission then executes the passed closure.

    - Parameter: The closure to execute after requesting notifications permission.
    */
    public func request(_ completionBlock: @escaping PermissionCallback) {
        notificationManager.pushNotificationRequestCompletion = { [weak self] result in
            completionBlock(result ? .allowed : .denied, nil)
            self?.notifyObservers(status: result ? .allowed : .denied)
        }
        notificationManager.requestRemoteNotificationsPermission()
    }

    public func status(_ completionBlock: @escaping PermissionCallback) {
        switch notificationManager.userPromptedForNotifications() {
        case true:
            notificationManager.isRemoteNotificationAuthorized { status in
                switch status {
                case true:
                    completionBlock(.allowed, nil)
                case false:
                    completionBlock(.denied, nil)
                }
            }
        default:
            completionBlock(.notDetermined, nil)
        }
    }

    public func notifyObservers(status: VFGPermissionStatus) {
        NotificationCenter.default.post(
            name: .PushNotificationPermissionChanged,
            object: status)
    }
}
