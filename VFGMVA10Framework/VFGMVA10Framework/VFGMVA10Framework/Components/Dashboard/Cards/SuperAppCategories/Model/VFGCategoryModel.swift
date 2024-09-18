//
//  VFGCategoryModel.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 22/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// **VFGCategoriesModel** is the main model for *VFGCategoriesView* view.
public struct VFGCategoriesModel: Codable {
    /// A boolean vlaue to determine if categories view should present items in one row only.
    public var presentInOneLine: Bool?
    /// A boolean vlaue to determine if category title should be showed.
    public var isGroupingShowMoreCategoriesEnabled: Bool?
    /// Array of *VFGCategoryModel*.
    public var categories: [VFGCategoryModel]?

    public init(
        presentInOneLine: Bool? = nil,
        isGroupingShowMoreCategoriesEnabled: Bool? = nil,
        categories: [VFGCategoryModel]?
    ) {
        self.presentInOneLine = presentInOneLine
        self.isGroupingShowMoreCategoriesEnabled = isGroupingShowMoreCategoriesEnabled
        self.categories = categories
    }
}

/// **VFGCategoryModel** is the model for a category item.
public struct VFGCategoryModel: Codable {
    /// Title of the category item.
    var title: String?
    /// Image name of the category item.
    var image: String?
    /// type name of the category item.
    var categoryTypeName: String?

    public init(
        title: String?,
        image: String?,
        categoryTypeName: String? = nil
    ) {
        self.title = title
        self.image = image
        self.categoryTypeName = categoryTypeName
    }
}
/// **VFGCategoriesSectionModel** is the model for a category section.
struct VFGCategoriesSectionModel {
    var title: String?
    var items: [VFGCategoryModel]?
}
