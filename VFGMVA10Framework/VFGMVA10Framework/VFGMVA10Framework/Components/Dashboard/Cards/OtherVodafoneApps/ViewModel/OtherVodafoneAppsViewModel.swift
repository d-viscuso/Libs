//
//  OtherVodafoneAppsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Ohter vodafone apps default view model
public class OtherVodafoneAppsViewModel {
    public let apps: OtherVodafoneAppsModel

    public init(apps: OtherVodafoneAppsModel) {
        self.apps = apps
    }
}

extension OtherVodafoneAppsViewModel: OtherVodafoneAppsDataSource {
    public func numberOfItems(in view: OtherVodafoneAppsView) -> Int {
        apps.subItems.count
    }

    public func otherVodafoneApps(_ view: OtherVodafoneAppsView, appForRowAt index: Int) -> OtherVodafoneAppsItemModel {
        apps.subItems[index]
    }
}
