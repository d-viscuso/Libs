//
//  CustomizationCardConfigurationModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 17/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Dashboard usage card edit card model
public struct CustomizationCardConfigurationModel: Decodable, Encodable, Equatable {
    /// Edit card usage type
    public var usageType: String
    /// Edit card index
    public var index: Int
    /// Determine if edit card is hidden or not
    public var isHidden: Bool
    /// Determine if edit card data is the default or not
    public var isDefault: Bool
    /// Edit card data
    public var metaData: [String: Any]?

    enum CodingKeys: CodingKey {
        case usageType
        case index
        case isHidden
        case isDefault
        case metaData
    }
    /// *CustomizationCardConfigurationModel* intializer
    /// - Parameters:
    ///    - usageType: Edit card usage type
    ///    - index: Edit card index
    ///    - isHidden: Determine if edit card is hidden or not
    ///    - isDefault: Determine if edit card data is the default or not
    ///    - metaData: Edit card data
    public init(
        usageType: String,
        index: Int,
        isHidden: Bool,
        isDefault: Bool,
        metaData: [String: Any]? = nil
    ) {
        self.usageType = usageType
        self.index = index
        self.isHidden = isHidden
        self.isDefault = isDefault
        self.metaData = metaData
    }
    /// *CustomizationCardConfigurationModel* data decoder intializer
    /// - Parameters:
    ///    - decoder: Edit card data decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        usageType = try container.decode(String.self, forKey: .usageType)
        index = try container.decode(Int.self, forKey: .index)
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        isDefault = try container.decode(Bool.self, forKey: .isDefault)
        metaData = try? container.decode([String: Any].self, forKey: .metaData)
    }
    /// *CustomizationCardConfigurationModel* data ecoder intializer
    /// - Parameters:
    ///    - decoder: Edit card data ecoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.usageType, forKey: .usageType)
        try container.encode(self.index, forKey: .index)
        try container.encode(self.isHidden, forKey: .isHidden)
        try container.encode(self.isDefault, forKey: .isDefault)
        try container.encode(of: self.metaData ?? [:], forKey: .metaData)
    }
    /// *CustomizationCardConfigurationModel* data comparison
    /// - Parameters:
    ///    - lhs: Left hand side comparison
    ///    - rhs: Right hand side comparison
    public static func == (lhs: CustomizationCardConfigurationModel, rhs: CustomizationCardConfigurationModel) -> Bool {
        lhs.usageType == rhs.usageType &&
        lhs.index == rhs.index &&
        lhs.isHidden == rhs.isHidden &&
        lhs.isDefault == rhs.isDefault
    }
}
/// Dashboard usage card edit card item keys
enum VFGCustomizationItemMetaDataKeys {
    static let title = "title"
    static let imageName = "imageName"
}
