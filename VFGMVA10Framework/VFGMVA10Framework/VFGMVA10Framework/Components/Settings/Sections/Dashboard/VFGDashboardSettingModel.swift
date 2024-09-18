//
//  VFGDashboardSettingModel.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 04/11/2021.
//

import Foundation
/// Dashboard settings model
public struct VFGDashboardSettingModel {
    /// Dashboard settings title
    public var title: String
    /// Dashboard settings title font
    public var titleFont: UIFont
    /// Dashboard settings icon name
    public var icon: String
    /// Dashboard settings cell type
    public var type: VFGChevronCellType
    /// *VFGDashboardSettingModel* initializer
    /// - Parameters:
    ///    - title: Dashboard settings title
    ///    - titleFont: Dashboard settings title font
    ///    - icon: Dashboard settings icon name
    ///    - type: Dashboard settings cell type
    public init(
        title: String,
        titleFont: UIFont,
        icon: String,
        type: VFGChevronCellType
    ) {
        self.title = title
        self.titleFont = titleFont
        self.icon = icon
        self.type = type
    }
}
