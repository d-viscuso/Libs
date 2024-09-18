//
//  VFGDashboardDataProvider+Config.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 11/07/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

extension VFGDashboardDataProvider {
    /// Prepare dashboard sections data
    /// - Parameters:
    ///    - sections: Array list of dashboard sections
    /// - Returns: Array list of model of base section view for each section in dashboard
    public class func prepareViewModel(_ sections: [VFGDashboardSection]) -> [BaseSectionViewModel] {
        var dataSource: [BaseSectionViewModel] = []
        let sectionTypes = VFGDashboardCardType.allCases.compactMap { $0.rawValue }
        for section in sections where sectionTypes.contains(section.type) {
            var entries: [BaseItemViewModel] = []
            for item in section.items ?? [] {
                var currentItem = item
                currentItem.metaData?[VFGroupedItemMetaDataKeys.accessibilityTitle] = section.title
                guard let dashboardModel = VFGDashboardItemViewModel(item: currentItem) else {
                    VFGErrorLog("Unable to init dashboardModel item:\(currentItem.toString() ?? "")")
                    continue
                }
                entries.append(dashboardModel)
            }
            let sectionModel = BaseSectionViewModel(title: section.title, type: section.type, items: entries)
            dataSource.append(sectionModel)
        }
        return dataSource
    }
}
