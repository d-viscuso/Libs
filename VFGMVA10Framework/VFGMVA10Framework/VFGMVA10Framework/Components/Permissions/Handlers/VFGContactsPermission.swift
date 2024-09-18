//
//  VFGContactsPermission.swift
//  VFGMVA10
//
//  Created by Yahya Saddiq on 8/20/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import Contacts

public class VFGContactsPermission: VFGPermissionProtocol {
    public var type: String { "" }

    /// Get contacts access authorization status.
    ///
    /// - Returns: The authorization status (.authorized, .denied, or .notDetermined)
    static func getAuthorizationStatus() -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }

    func authorizationStatus() -> CNAuthorizationStatus {
        return VFGContactsPermission.getAuthorizationStatus()
    }

    /// Requests contacts access authorization.
    ///
    /// - Parameter completionHandler: the closure to execute on finish
    public func request(_ completionBlock: @escaping PermissionCallback) {
        let contactStore = CNContactStore()
        switch authorizationStatus() {
        case .authorized:
            completionBlock(.allowed, nil)
            notifyObservers(status: .allowed)
        case .denied, .notDetermined:
            contactStore.requestAccess(for: .contacts, completionHandler: { [weak self] granted, _ -> Void in
                DispatchQueue.main.async {
                    if granted {
                        // granted
                        completionBlock(.allowed, nil)
                        self?.notifyObservers(status: .allowed)
                    } else {
                        // denied
                        completionBlock(.denied, nil)
                        self?.notifyObservers(status: .denied)
                    }
                }
            })
        default:
            completionBlock(.denied, nil)
        }
    }

    /// Requests contacts access status.
    ///
    /// - Parameter completionHandler: the closure to execute on finish
    public func status(_ completionBlock: @escaping PermissionCallback) {
        switch authorizationStatus() {
        case .authorized:
            return completionBlock(.allowed, nil)
        case .notDetermined, .restricted:
            return completionBlock(.notDetermined, nil)
        case .denied:
            return completionBlock(.denied, nil)
        @unknown default:
            return completionBlock(.notDetermined, nil)
        }
    }

    public func notifyObservers(status: VFGPermissionStatus) {
        NotificationCenter.default.post(
            name: .ContactPermissionChanged,
            object: status)
    }
}
