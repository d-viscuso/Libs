//
//  VFGLocationPermission.swift
//  VFGMVA10
//
//  Created by Hussien Gamal Mohammed on 7/16/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import CoreLocation
import VFGMVA10Foundation

class VFGLocationPermission: NSObject, VFGPermissionProtocol {
    var type: String { "" }

    let locationAlwaysUsageDescription = "NSLocationAlwaysUsageDescription"
    let locationWhenInUseUsageDescription = "NSLocationWhenInUseUsageDescription"
    let locationManager = CLLocationManager()

    var completionBlock: PermissionCallback?
    var locationPermissionType: VFGPermissionType?
    var bundle: Bundle?
    /// When location permission is requested, didChangeAuthorization method is being called twice,
    /// first one when requesting the permission and the second one when the user select option from popUp
    /// The completion should be triggered once after user select option
    var isFirstTimeAuthorizationChanged = false

    init(_ permissionType: VFGPermissionType?, bundle: Bundle) {
        super.init()
        self.bundle = bundle
        locationPermissionType = permissionType
    }

    func request(_ completionBlock: @escaping PermissionCallback) {
        locationManager.delegate = self
        self.completionBlock = completionBlock
        executeRequest()
    }

    func status(_ completionBlock: @escaping PermissionCallback) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse: completionBlock(.allowed, nil)
        case .notDetermined:  completionBlock(.notDetermined, nil)
        case .restricted, .denied: completionBlock(.denied, nil)
        @unknown default: completionBlock(.notDetermined, nil)
        }
    }

    func notifyObservers(status: VFGPermissionStatus) {
        NotificationCenter.default.post(
            name: .LocationPermissionChanged,
            object: status)
    }
}

// MARK: internal methods
extension VFGLocationPermission {
    func keyInInfoPlist(_ key: String) {
        guard bundle?.object(forInfoDictionaryKey: key) != nil else {
            assertionFailure("\(key) not found in Info.plist")
            return
        }
    }

    func executeRequest() {
        switch locationPermissionType {
        case .locationAlways?:
            keyInInfoPlist(locationAlwaysUsageDescription)
            locationManager.requestAlwaysAuthorization()
            if let completionBlock = completionBlock {
                status(completionBlock)
            }

        case .locationWhileUsage?:
            keyInInfoPlist(locationWhenInUseUsageDescription)
            locationManager.requestWhenInUseAuthorization()
            if let completionBlock = completionBlock {
                status(completionBlock)
            }

        default:
            completionBlock?(.notDetermined, nil)
        }
    }
}

// MARK: - location manager delegate
extension VFGLocationPermission: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var permissionStatus: VFGPermissionStatus?
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            permissionStatus = .allowed
        case .restricted, .denied:
            permissionStatus = .denied
        case .notDetermined:
            permissionStatus = .notDetermined
        @unknown default:
            permissionStatus = .notDetermined
        }
        guard let authorizationStatus = permissionStatus else { return }
        notifyObservers(status: authorizationStatus)

        /// authorizationStatus != .notDetermined will work only when authorization is already requested before
        /// and no popUp will be shown, so the completion will be triggered with saved status
        if isFirstTimeAuthorizationChanged || authorizationStatus != .notDetermined {
            completionBlock?(authorizationStatus, nil)
        }
        isFirstTimeAuthorizationChanged = true
    }
}
