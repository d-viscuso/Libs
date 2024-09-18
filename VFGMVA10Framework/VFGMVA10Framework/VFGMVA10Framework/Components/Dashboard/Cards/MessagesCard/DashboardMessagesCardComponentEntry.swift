//
//  DashboardMessagesCardComponentEntry.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 06/12/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard messages card entry
public class DashboardMessagesCardComponentEntry: NSObject, VFGComponentEntry {
    var view: DashboardMessagesCard?
    var userDefaults = UserDefaults.standard

    public var cardEntryViewController: UIViewController? {
        return nil
    }

    public required init(config: [String: Any]?, error: [String: Any]?) {
        view = DashboardMessagesCard(
            errorMessage: error?["errorMessage"] as? String
        )
        view?.accessibilityIdentifier = "DBmessagesCard"
    }

    public var cardView: UIView? {
        return view
    }

    public func didSelectCard() {
        VFGManagerFramework.appSettingsDelegate?.presentMessageCenterViewController(notificationMessageId: nil)
    }
}
