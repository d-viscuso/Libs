//
//  VFGDashboardItemsProtocolDefaults.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 30/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

enum VFGDashboardItemsProtocolDefaults {
    static let refreshManager = VFGRefreshManager(lastUpdatedTimeKey: "dashboardLastUpdatedTime")
    static let refreshStatusModel = VFGRefreshStatusModel(
        updatingText: "lastupdatedlabel_updating".localized(bundle: .mva10Framework),
        justUpdatedText: "lastupdatedlabel_justupdated".localized(bundle: .mva10Framework),
        updatedMinText: "lastupdatedlabel_minute".localized(bundle: .mva10Framework),
        updatedMinsText: "lastupdatedlabel_minutes".localized(bundle: .mva10Framework),
        timeStampText: "lastupdatedlabel_timestamp".localized(bundle: .mva10Framework)
    )
}
