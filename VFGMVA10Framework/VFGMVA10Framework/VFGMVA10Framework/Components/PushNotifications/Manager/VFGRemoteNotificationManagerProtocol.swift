//
//  VFGRemoteNotificationManagerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/16/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Remote notification manager protocol.
public protocol VFGRemoteNotificationManagerProtocol: AnyObject {
    /// Unread messages count.
    var latestUnreadMessagesCount: Int? { get }
    /// Method to configure notification provider.
    func configureProvider()
    /// Request push notification permission from user.
    /// - Parameters:
    ///     - completion: status is a boolean with the state of the push notification permission if it was accpeted or declined.
    func requestPushNotificationPermission(_ completion: @escaping (_ status: Bool) -> Void)
    /// Method to return the state if the user is prompted for notifications or not.
    func userPromptedForNotifications() -> Bool
    /// Method to add messages observer to *NotificationCenter*.
    func addNewMessagesObserver()
    /// Mehtod to check unread messages count.
    func unreadMessagesCount(_ completion: @escaping (Int) -> Void)
    /// Method to mark all messages as read.
    func markMessagesRead()
    /// Method to return badge model instance.
    func badgeModel() -> BadgeModel
}

public extension VFGRemoteNotificationManagerProtocol {
    var latestUnreadMessagesCount: Int? {
        nil
    }
    func markMessagesRead() {}
}
