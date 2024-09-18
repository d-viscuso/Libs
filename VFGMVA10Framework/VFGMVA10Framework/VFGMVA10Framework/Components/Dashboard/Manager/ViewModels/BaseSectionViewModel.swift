//
//  BaseSectionViewModel.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 26/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Model of base section view for each section in dashboard.
public struct BaseSectionViewModel {
    /// Section title. If it's nil or empty no title will be shown.
    public var title: String?
    /// Dashboard section type, it's either *dashboard, discovery or none*.
    public var type: String?
    /// Array of each section's items.
    public var items: [BaseItemViewModel]?
    /// *BaseSectionViewModel* initializer
    /// - Parameters:
    ///    - title: Section title. If it's nil or empty no title will be shown.
    ///    - type: Dashboard section type, it's either *dashboard, discovery or none*.
    ///    - items: Array of each section's items.
    public init(title: String?, type: String?, items: [BaseItemViewModel]?) {
        self.title = title
        self.type = type
        self.items = items
    }
}
