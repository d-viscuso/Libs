//
//  StoriesDXLResponse.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 12.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - StoriesDXLResponse
/// Stories DXL model
public struct StoriesDXLResponse: Codable {
    let recommendationItem: [StoriesRecommendationItem]?
    let category: [StoriesCategory]?
    let channel: [StoriesCategory]?
    let recommendationType: String?
}

// MARK: - StoriesRecommendationItem
/// Stories recommendation item model
public struct StoriesRecommendationItem: Codable {
    let id: String?
    let priority: Int?
    let type: StoryType
    /// Multiple stories have multiple products
    let products: [StoriesProduct]?
}

// MARK: - StoriesProduct
/// Stories stories product model
public struct StoriesProduct: Codable {
    let id: String?
    let description: String?
    let name: String?
    let productCharacteristic: [StoriesProductCharacteristic]?
    let productTerm: [StoriesProductTerm]?
    let productSpecification: StoriesProductSpecification?
    let productGrid: GridData?
}

// MARK: - StoriesProductCharacteristic
/// Stories product characteristic model
public struct StoriesProductCharacteristic: Codable {
    let id: String?
    let name: String?
    let valueType: String?
    let baseType: String?
    let type: String?
}

// MARK: - StoriesProductTerm
/// Stories product term model
public struct StoriesProductTerm: Codable {
    let validFor: StoriesValidFor?
}

// MARK: - StoriesValidFor
/// Stories valid for model
public struct StoriesValidFor: Codable {
    let endDateTime: String?
    let startDateTime: String?
}

// MARK: - StoriesProductSpecification
/// Stories product specification model
public struct StoriesProductSpecification: Codable {
    let id: String?
    let href: String?
    let href2: String?
}

// MARK: - StoriesCategory
/// Stories category model
public struct StoriesCategory: Codable {
    let id: String?
    let href: String?
    let name: String?
    let version: String?
}

// MARK: - StoriesGridItem
/// Stories grid layout model
public struct StoriesGridItem: Codable {
    let id: String?
    let image: String?
    let title: String?
    let price: String?
}

// MARK: - StoriesGridData
/// Stories grid data model
public struct GridData: Codable {
    var firstRow: GridRowData?
    var secondRow: GridRowData?
}

// MARK: - StoriesGridRowData
/// Stories grid row data model
public struct GridRowData: Codable {
    let firstItem: GridItemData
    let secondItem: GridItemData
}

// MARK: - StoriesGridItemData
/// Stories grid item data model
public struct GridItemData: Codable {
    let imageUrl: String
    let title: String
    let subtitle: String?
    let link: String?
}
