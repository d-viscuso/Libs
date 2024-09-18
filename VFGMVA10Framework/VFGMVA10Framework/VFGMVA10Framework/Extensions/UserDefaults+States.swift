//
//  UserDefaults+States.swift
//  VFGMVA10Group
//
//  Created by Tomasz Czyżak on 10/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let appPrivacy = "appPrivacyKey"
        static let dashboardLastUpdatedTime = "dashboardLastUpdatedTime"
        static let productsLastUpdatedTime = "productsLastUpdatedTime"
        static let isMultipleAccountBannerShown = "isMultipleAccountBannerShown"
    }

    /// Sets and gets *Date* for key *dashboardLastUpdatedTime*.
    public var dashboardLastUpdatedTime: Date {
        get {
            guard let date = value(forKey: Keys.dashboardLastUpdatedTime) as? Date else {
                self.dashboardLastUpdatedTime = Date()
                return Date()
            }
            return date
        }
        set {
            set(newValue, forKey: Keys.dashboardLastUpdatedTime)
        }
    }

    /// Sets and gets *Date* for key *productsLastUpdatedTime*.
    public var productsLastUpdatedTime: Date {
        get {
            guard let date = value(forKey: Keys.productsLastUpdatedTime) as? Date else {
                self.productsLastUpdatedTime = Date()
                return Date()
            }
            return date
        }
        set {
            set(newValue, forKey: Keys.productsLastUpdatedTime)
        }
    }

    /// Sets and gets *Bool* for key *appPrivacy*.
    public var appPrivacy: Bool {
        get {
            return (object(forKey: Keys.appPrivacy) == nil) ? true : bool(forKey: Keys.appPrivacy)
        }
        set {
            set(newValue, forKey: Keys.appPrivacy)
        }
    }

    /// Sets and gets *Bool* for key *isMultipleAccountBannerShown*.
    public var isMultipleAccountBannerShown: Bool {
        get {
            return bool(forKey: Keys.isMultipleAccountBannerShown)
        }
        set {
            set(newValue, forKey: Keys.isMultipleAccountBannerShown)
        }
    }
}
