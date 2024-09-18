//
//  PrivacySettingsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 13/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Privacy settings main screen view model
class PrivacySettingsViewModel {
    /// An instance of  *PrivacySettingsDataProviderProtocol* to fetch data
    var dataProvider: PrivacySettingsDataProviderProtocol?
    /// An instance of  *PrivacySettingsModel*
    var privacySettingsModel: PrivacySettingsModel?
    /// Privacy settings main screen view model initializer
    ///  - Parameters:
    ///     - dataProvider: Given data provider to fetch data
    init(dataProvider: PrivacySettingsDataProviderProtocol?) {
        self.dataProvider = dataProvider
    }
    /// Responsible for handling the result of fetching privacy settings data
    /// - Parameters:
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchPrivacySettings(completion: (() -> Void)? = nil) {
        dataProvider?.fetchPrivacySettings { [weak self] model, error in
            guard let self = self, error == nil else {
                return
            }
            guard let privacySettingsModel = model else {
                return
            }

            self.privacySettingsModel = privacySettingsModel
            completion?()
        }
    }
    /// Return privacy settings main screen header title text
    func privacySettingsHeaderTitle() -> String? {
        privacySettingsModel?.header
    }
    /// Return privacy settings main screen contents count
    func numberOfContents() -> Int? {
        privacySettingsModel?.contents.count
    }
    /// Return privacy settings main screen contents for selected row
    func getContent(at row: Int) -> PrivacySettingsContentModel? {
        privacySettingsModel?.contents[row]
    }
}
