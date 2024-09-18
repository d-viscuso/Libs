//
//  VFGPersonalizedNetworkPermissionDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 13/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A protocol for *VFGPersonalizedNetworkPermission* processes
public protocol VFGPersonalizedNetworkPermissionDelegate: AnyObject {
    /// - Returns: The subscriber's MISDN in INTERNATIONAL format (OPTIONAL) The MSISDN has to be provided in INTERNATIONAL format if exsits
    /// - Parameters:
    ///    - info: Optional dictionary to get MSISDN
    ///    - completionBlock: An optional completion that holds current *VFGPermissionStatus* and an optional *Error*
    ///    - status: Current permission status
    ///    - error: Error if MSISDN isn't found
    func checkMSISDNExsitance(
        in info: [String: Any]?,
        with completionBlock: PermissionCallback?
    ) -> String
    /// Set *completionBlock* with given status and error if found
    /// - Parameters:
    ///    - completionBlock: An optional completion that holds current *VFGPermissionStatus* and an optional *Error*
    ///    - status: Current permission status
    ///    - error: Error if MSISDN isn't found
    func setCompletionBlock(
        _ completionBlock: PermissionCallback?,
        withStatus status: VFGPermissionStatus,
        and error: Error?
    )
    /// Notify observers with given status
    /// - Parameters:
    ///    - status: Current permission status
    func permissionNotifyObservers(status: VFGPermissionStatus)
    /// - Returns: Error if MSISDN isn't found
    func invalidMSISDNError() -> NSError
    /// - Returns: Error if changing status failed
    func changeStatusError() -> NSError
    /// Notify for permission denied state
    /// - Parameters:
    ///    - completionBlock: An optional completion that holds current *VFGPermissionStatus* and an optional *Error*
    func stateOnSkipped(with completionBlock: PermissionCallback?)
    /// Notify for permission allowed state
    /// - Parameters:
    ///    - completionBlock: An optional completion that holds current *VFGPermissionStatus* and an optional *Error*
    func stateOnSuccess(with completionBlock: PermissionCallback?)
}

public extension VFGPersonalizedNetworkPermissionDelegate {
    func checkMSISDNExsitance(
        in info: [String: Any]?,
        with completionBlock: PermissionCallback?
    ) -> String {
        guard let msisdn = info?["msisdn"] as? String else {
            setCompletionBlock(
                completionBlock,
                withStatus: .notDetermined,
                and: invalidMSISDNError())
            permissionNotifyObservers(status: .notDetermined)
            return ""
        }
        return msisdn
    }

    func setCompletionBlock(
        _ completionBlock: PermissionCallback?,
        withStatus status: VFGPermissionStatus,
        and error: Error?
    ) {
        completionBlock?(status, error)
    }

    func permissionNotifyObservers(status: VFGPermissionStatus) {
        NotificationCenter.default.post(
            name: .PersonalizedNetworkPermissionChanged,
            object: status)
    }

    func invalidMSISDNError() -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: "Invalid MSISDN"]
        return NSError(domain: "VFGPersonalizedNetworkPermission", code: 1, userInfo: userInfo)
    }

    func changeStatusError() -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey:
            "Netperform failed to change personalized network status, make sure to pass a valid MSISDN"
        ]
        return NSError(domain: "VFGPersonalizedNetworkPermission", code: 1, userInfo: userInfo)
    }

    func stateOnSkipped(with completionBlock: PermissionCallback?) {
        guard let completionBlock = completionBlock else {
            return
        }
        completionBlock(.denied, changeStatusError())
        permissionNotifyObservers(status: .denied)
    }

    func stateOnSuccess(with completionBlock: PermissionCallback?) {
        guard let completionBlock = completionBlock else {
            return
        }
        completionBlock(.allowed, nil)
        permissionNotifyObservers(status: .allowed)
    }
}
