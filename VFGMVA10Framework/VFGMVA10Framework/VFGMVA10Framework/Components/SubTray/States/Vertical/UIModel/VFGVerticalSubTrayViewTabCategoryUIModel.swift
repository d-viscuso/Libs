//
//  VFGVerticalSubTrayViewTabCategoryUIModel.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// List of categories for vertical sub tray tab
enum VFGVerticalSubTrayViewTabCategoryUIModel {
    /// All categories
    case all
    /// Other categories
    /// - Parameters:
    ///    - category: Selected category to display
    case other(_ category: String)
}
