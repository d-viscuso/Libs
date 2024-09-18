//
//  VFGNetworkPermission.swift
//  VFGMVA10Group
//
//  Created by Hussien Gamal Mohammed on 7/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class VFGNetworkPermission: VFGPermissionProtocol {
    public var type: String { "" }
    weak var delegate: VFGNetworkPermissionDelegate?

    init(delegate: VFGNetworkPermissionDelegate? = nil) {
        self.delegate = delegate
    }

    public func request(_ completionBlock: @escaping PermissionCallback) {}

    public func set(status: Bool, _ completionBlock: PermissionCallback?, info: [String: Any]?) {
        delegate?.createNetperformInstanceIfNeeded()

        if status {
            delegate?.start()
            notifyObservers(status: .allowed)
        } else {
            delegate?.stop()
            notifyObservers(status: .denied)
        }
    }

    public func status(_ completionBlock: @escaping PermissionCallback) {
        delegate?.createNetperformInstanceIfNeeded()

        if let isOptedIn = delegate?.isOptedIn {
            if isOptedIn == 1 {
                completionBlock(.allowed, nil)
            } else {
                completionBlock(.denied, nil)
            }
        } else {
            completionBlock(.notDetermined, nil)
        }
    }

    public func notifyObservers(status: VFGPermissionStatus) {
        NotificationCenter.default.post(
            name: .NetworkPermissionChanged,
            object: status)
    }
}
/// A protocol to get required data & perform processes that belongs to *NetPerformSDK* for network permissions
public protocol VFGNetworkPermissionDelegate: AnyObject {
    /// Check if the NetPerform SDK is in the opted-in state
    var isOptedIn: NSNumber? { get }
    /// Check the current status of the personalized mode (anonmyized vs. personalized)
    var isPersonalized: NSNumber? { get }
    /// Start (opt-in) the NetPerform SDK and enable measurements (e.g. speed tests) and transmission of measurements results to the server
    func start()
    /// Stop (opt-out) from the NetPerform SDK thus disabling speed tests and other measurements
    func stop()
    /// Get the (singleton) context for the NetPerform SDK
    /// If found, It Initializes the NPContext and performs the basic setup of the NetPerformSDK. It creates the shared instance, loads the necessary configuration parameters, and may also starts the NetPerformSDK
    func createNetperformInstanceIfNeeded()
}
