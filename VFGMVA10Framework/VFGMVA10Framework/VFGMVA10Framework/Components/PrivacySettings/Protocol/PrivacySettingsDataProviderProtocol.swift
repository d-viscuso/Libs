//
//  PrivacySettingsDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 13/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Data provider protocol for privacy settings journey
public protocol PrivacySettingsDataProviderProtocol {
    /// Responsible for handling the result of fetching privacy settings main screen data
    /// - Parameters:
    ///    - completion: Holds the result of fetching data whether success or failure
    func fetchPrivacySettings(completion: @escaping (PrivacySettingsModel?, Error?) -> Void)
    /// Responsible for handling the result of fetching privacy settings personalized recommendations screen data
    /// - Parameters:
    ///    - completion: Holds the result of fetching data whether success or failure
    func fetchPersonalizedRecommendations(completion: ((PrivacySettingsPermissionsModel?, Error?) -> Void)?)
    /// Responsible for handling the result of fetching privacy settings contact preferences screen data
    /// - Parameters:
    ///    - completion: Holds the result of fetching data whether success or failure
    func fetchContactPreferences(completion: ((PrivacySettingsPermissionsModel?, Error?) -> Void)?)
    /// Responsible for handling the result of fetching privacy settings app tracking screen data
    /// - Parameters:
    ///    - completion: Holds the result of fetching data whether success or failure
    func fetchAppTracking(completion: ((PrivacySettingsPermissionsModel?, Error?) -> Void)?)
}

extension PrivacySettingsDataProviderProtocol {
    func fetchPersonalizedRecommendations(completion: ((PrivacySettingsPermissionsModel?, Error?) -> Void)?) {}
    func fetchContactPreferences(completion: ((PrivacySettingsPermissionsModel?, Error?) -> Void)?) {}
    func fetchAppTracking(completion: ((PrivacySettingsPermissionsModel?, Error?) -> Void)?) {}
}
