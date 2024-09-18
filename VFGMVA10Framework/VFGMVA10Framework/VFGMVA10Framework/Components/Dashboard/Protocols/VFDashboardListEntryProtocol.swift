//
//  VFDashboardListEntry.swift
//  VFGMVA10
//
//  Created by Mahmoud Amer on 8/4/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

// For providing dashboard card entry containing a list
/// Protocol for dashboard grouped items sections entry list
public protocol VFDashboardListEntryProtocol: AnyObject {
    /// Dashboard grouped item
    var item: VFGDashboardItem? { get set }
    /// Dashboard grouped items section show more button height
    var showMoreHeight: CGFloat? { get set }
    /// Dashboard grouped items section show more button action
    var showMoreAction: ((Bool) -> Void)? { get set }
    /// Determine if dashboard grouped items section has show more button or not
    var hasShowMore: Bool? { get set }
}
