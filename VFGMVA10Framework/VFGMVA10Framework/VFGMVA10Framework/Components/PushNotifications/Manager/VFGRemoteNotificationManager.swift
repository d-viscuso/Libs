//
//  VFGRemoteNotificationManager.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 9/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Remote notification manager.
public class VFGRemoteNotificationManager {
    /// The singleton *VFGRemoteNotificationManager* instance.
    public static let shared = VFGRemoteNotificationManager()
    /// Remote notification manager delegate *VFGRemoteNotificationManagerProtocol?*.
    public weak var delegate: VFGRemoteNotificationManagerProtocol?
    /// Completion with boolean of the state of the permission request if it was accpeted or declined.
    public var pushNotificationRequestCompletion: ((Bool) -> Void)?
    public var didOpenFromNotification = false
    public var notificationMessageId: String?
    /// Number of unread notifications.
    public var unreadCount: Int = 0
    var badgeModel: BadgeModel?

    init() {
        warnIfSimulator()
    }

    /// Method to configure notification provider.
    public func configureProvider() {
        delegate?.configureProvider()
        delegate?.addNewMessagesObserver()
        badgeModel = delegate?.badgeModel()
    }

    /// Method returns the state if the user is prompted for notifications or not.
    public func userPromptedForNotifications() -> Bool {
        guard let delegate = delegate else {
            return false
        }

        return delegate.userPromptedForNotifications()
    }

    func isRemoteNotificationAuthorized(completion: @escaping (Bool) -> Void) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings { settings in
            if settings.authorizationStatus == .denied {
                completion(false)
            } else if settings.authorizationStatus == .authorized {
                completion(true)
            }
        }
    }

    /// Method to request push notification permission from user.
    public func requestRemoteNotificationsPermission() {
        guard let delegate = delegate else {
            if let requestCompletion = pushNotificationRequestCompletion {
                requestCompletion(false)
            }
            return
        }

        delegate.requestPushNotificationPermission { [weak self] status in
            guard let requestCompletion = self?.pushNotificationRequestCompletion else {
                return
            }
            requestCompletion(status)
        }
    }

    /// gets latest messages list, then:
    /// notifies all listeners for unread count
    /// and updates app icon badge number
    public func latestUnreadMessagesCountAndNotifyListeners() {
        guard let unreadMessagesCount = delegate?.latestUnreadMessagesCount,
            unreadCount != unreadMessagesCount else {
            return
        }
        unreadCount = unreadMessagesCount
        notifyListenersAndUpdateAppIconBadge()
    }

    /// Retrieves message list, then:
    /// notifies all listeners for unread count
    /// and updates app icon badge number
    public func retrieveUnreadMessagesCountAndNotifyListeners() {
        delegate?.unreadMessagesCount { [weak self] count in
            guard let self = self,
                self.unreadCount != count else { return }
            self.unreadCount = count
            self.notifyListenersAndUpdateAppIconBadge()
        }

        // this is used to notify new subscribers with the current unreadCount
        // instead of just waiting for the new unreadCount
        notifyListenersAndUpdateAppIconBadge()
    }

    /// Method to mark all messages as read.
    public func markMessagesRead() {
        delegate?.markMessagesRead()
    }

    /// Method to notify listeners and update app icon badge count.
    public func notifyListenersAndUpdateAppIconBadge() {
        badgeModel?.text = "\(unreadCount)"
        if let model = badgeModel {
            VFGBadgesTracker.shared.updateBadge(
                with: Constants.messageCenterBadgeID,
                model: model)
        }

        guard UIApplication.shared.applicationIconBadgeNumber != unreadCount else {
            // skip updating appIcon, if notification provider(airship, etc.) updated it
            return
        }

        isRemoteNotificationAuthorized { [weak self] status in
            if status == true, let self = self {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    UIApplication.shared.applicationIconBadgeNumber = self.unreadCount
                }
            }
        }
    }

    /// Method to handle inbox push notifications.
    @discardableResult
    public func handleInboxPushNotification(_ action: VFGPushNotificationActions, notificationMessageId: String? = nil) -> Bool {
        guard action == .launchedFromPush || action == .backgroundPush else {
            return false
        }
        self.notificationMessageId = notificationMessageId
        // Show message center if dashboard is showing or the app became active from background
        let stateName =
            VFGManagerFramework.stateDelegate?.stateManager.currentState?.name
        guard stateName != "VFGMVA10Group.ReadyState" else {
            VFGManagerFramework.appSettingsDelegate?.presentMessageCenterViewController(
                notificationMessageId: notificationMessageId)
            return false
        }

        // otherwise, show message center when the dashboard is ready
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(presentMessageCenterAndRemoveObserver),
            name: .VFGAppLaunchedFromInboxPush,
            object: nil
        )
        return true
    }

    @discardableResult
    @objc func presentMessageCenterAndRemoveObserver() -> Bool {
        guard didOpenFromNotification else {
            return false
        }
        VFGManagerFramework.appSettingsDelegate?.presentMessageCenterViewController(
            notificationMessageId: notificationMessageId)
        NotificationCenter.default.removeObserver(self, name: .VFGAppLaunchedFromInboxPush, object: nil)
        didOpenFromNotification = false
        return true
    }

    func warnIfSimulator() {
        // If it's not a simulator return early
        guard TARGET_OS_SIMULATOR != 0 && TARGET_IPHONE_SIMULATOR != 0 else {
            return
        }
        VFGWarningLog("You will not be able to receive push notifications in the simulator.")
    }
}

/// Push notification actions.
public enum VFGPushNotificationActions: String {
    /**
    * Represents a situation in which a push notification was received in the foreground.
    */
    case foregroundPush

    /**
    * Represents a situation in which a push notification was received in the background.
    */
    case backgroundPush

    /**
    * Represents a situation in which the application was launched from a push notification.
    */
    case launchedFromPush
}
