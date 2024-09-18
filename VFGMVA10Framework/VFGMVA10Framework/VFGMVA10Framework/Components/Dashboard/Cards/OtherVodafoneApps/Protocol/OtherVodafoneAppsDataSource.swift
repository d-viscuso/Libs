//
//  OtherVodafoneAppsDataSource.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 22/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A data source protocol that manages the data in your other vodafone apps component.
/// It represents your data model and vends information to the other vodafone apps as needed
/// It creates and configures the other vodafone apps views to display your data
public protocol OtherVodafoneAppsDataSource: AnyObject {
    /// Provide number of apps which is viewed across other vodafone apps component.
    /// - Parameter view: Current other vodafone apps view associated with the data source.
    /// - Returns: An *Int* value which represents number of applications.
    func numberOfItems(in view: OtherVodafoneAppsView) -> Int
    /// Access specific app at given index.
    /// - Parameters:
    ///   - view: Current other vodafone apps view associated with the data source.
    ///   - index: An *Int* value used to specify app at that index.
    /// - Returns: An object of type *OtherVodafoneAppsItemModel* which represents the app model at specific index.
    func otherVodafoneApps(_ view: OtherVodafoneAppsView, appForRowAt index: Int) -> OtherVodafoneAppsItemModel
}
