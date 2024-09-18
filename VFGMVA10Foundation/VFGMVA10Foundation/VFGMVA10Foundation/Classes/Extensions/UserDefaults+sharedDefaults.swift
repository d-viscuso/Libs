//
//  UserDefaults+sharedDefaults.swift
//  VFGMVA10Foundation
//
//  Created by Moustafa Hegazy on 02/03/2021.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let msisdn = "msisdn"
        static let multiTabsLastUpdatedTime = "multiTabsLastUpdatedTime"
    }

    /// Unique MSISDN number of the user in string format.
    public var msisdn: String {
        get {
            return read(forKey: Keys.msisdn) ?? ""
        }
        set {
            save(item: newValue, forKey: Keys.msisdn)
        }
    }

    /// Date that tells the last time multi tabs is ubdated.
    public var multiTabsLastUpdatedTime: Date {
        get {
            guard let date = value(forKey: Keys.multiTabsLastUpdatedTime) as? Date else {
                self.multiTabsLastUpdatedTime = Date()
                return Date()
            }
            return date
        }
        set {
            set(newValue, forKey: Keys.multiTabsLastUpdatedTime)
        }
    }
}
