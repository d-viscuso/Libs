//
//  VFGKeyChainService.swift
//  VFGDataAccess
//
//  Created by Esraa Eldaltony on 3/24/19.
//  Copyright © 2019 VFG. All rights reserved.
//

import Foundation
import Security
/// Service for saving and securing data
public class VFGKeyChainService: NSObject {
    // Constant Identifiers
    private static let userAccount = "AuthenticatedUser"
    private static let accessGroup = "SecuritySerivice"
    /// Remove key chain saved queries
    public class func reset() {
        resetKeychain()
    }
    /// Save data to key chain
    /// - Parameters:
    ///    - key: Key for given to be saved, represents the service name
    ///    - value: Given data to be saved
    public class func saveData(key: String, value: Data) {
        saveData(service: key, data: value)
    }
    /// Retrieve data from key chain
    /// - Parameters:
    ///    - key: Key for saved data to retrieve, represents the service name
    /// - Returns: Saved data for given key
    public class func data(forKey key: String) -> Data? {
        return loadData(key: key)
    }

    /**
    * Internal methods for querying the keychain.
    */
    private class func saveData(service: String, data: Data) {
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary =
            NSMutableDictionary(
                objects: [
                    kSecClassGenericPassword,
                    service,
                    userAccount,
                    data
                ],
                forKeys: [
                    kSecClass as NSString,
                    kSecAttrService as NSString,
                    kSecAttrAccount as NSString,
                    kSecValueData as NSString
                ]
        )

        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)

        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    private class func loadData(key: String) -> Data? {
        return load(service: key)
    }

    private class func load<T>(service: String) -> T? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary =
            NSMutableDictionary(
                objects: [
                    kSecClassGenericPassword,
                    service,
                    userAccount,
                    kCFBooleanTrue as Any,
                    kSecMatchLimitOne
                ],
                forKeys: [
                    kSecClass as NSString,
                    kSecAttrService as NSString,
                    kSecAttrAccount as NSString,
                    kSecReturnData as NSString,
                    kSecMatchLimit as NSString
                ]
        )

        var dataTypeRef: AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: T?

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = retrievedData as? T
            }
        } else {
            VFGDebugLog("Nothing was retrieved from the keychain for key \(service). Status code \(status)")
        }
        return contentsOfKeychain
    }

    private class func resetKeychain() {
        let query = [
            (kSecClass as String): kSecClassGenericPassword
        ]
        if SecItemDelete(query as CFDictionary) != noErr {
            VFGDebugLog("Couldn't clear keychain.")
        }
    }
}
