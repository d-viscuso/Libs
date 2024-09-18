//
//  BaseItemViewModel.swift
//  VFGMVA10
//
//  Created by Mahmoud Amer on 1/15/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Model of base item view for each card inside it's section in dashboard.
open class BaseItemViewModel {
    /// Dashboard item card data model
    public var componentEntry: VFGComponentEntry?
    /// Dashboard item height
    public var itemHeight: CGFloat?
    /// Dashboard item data model
    public var data: VFGDashboardItem?
    /// Determine whether the shadow should be enabled or not
    public var isShadowEnabled = true
    /// Optional Padding
    public var padding: CGFloat = 0
    public init() {}
    /// *BaseItemViewModel* intializer
    /// - Parameters:
    ///    - componentEntry: Dashboard item card data model
    ///    - itemHeight: Dashboard item height
    ///    - data: Dashboard item data model
    ///    - isShadowEnabled: Determine whether the shadow should be enabled or not
    public init(
        componentEntry: VFGComponentEntry?,
        itemHeight: CGFloat?,
        data: VFGDashboardItem,
        isShadowEnabled: Bool = true
    ) {
        self.componentEntry = componentEntry
        self.itemHeight = itemHeight
        self.data = data
        self.isShadowEnabled = isShadowEnabled
    }
}
