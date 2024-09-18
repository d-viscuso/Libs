//
//  VFGTooltipsManagerDataSource.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 17/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A datasource protocol manages tooltips contents,
public protocol VFGTooltipsManagerDataSource: AnyObject {
    /// Number of all available tooltips
    func numberOfTooltips() -> Int

    /// Tooltip item data
    /// - Parameters:
    ///   - number: The number of tooltip
    func tooltipItem(of number: Int) -> VFGTooltipItem?
}
