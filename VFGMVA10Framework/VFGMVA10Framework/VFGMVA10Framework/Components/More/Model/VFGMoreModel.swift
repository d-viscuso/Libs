//
//  VFGMoreModel.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 21/11/2022.
//

import Foundation

/// VFGMoreModel  model
public struct VFGMoreModel: Codable {
    public var isSearchBarIsEnabled: Bool?
    public var sections: [VFGMoreSectionModel]?

    // MARK: - init
    public init(
        isSearchBarIsEnabled: Bool,
        sections: [VFGMoreSectionModel]
    ) {
        self.isSearchBarIsEnabled = isSearchBarIsEnabled
        self.sections = sections
    }
}

/// *VFGMoreSectionModel * model
public struct VFGMoreSectionModel {
    public var sectionType: SectionType?
    public var directionType: DirectionType?
    public var items: [VFGMoreItemModel]?

    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case items
        case directionType
        case sectionType
    }
    // MARK: - init
    public init(
        sectionType: SectionType,
        directionType: DirectionType,
        items: [VFGMoreItemModel]
    ) {
        self.sectionType = sectionType
        self.items = items
        self.directionType = directionType
    }
}

// MARK: - SectionType
public enum SectionType: String, Codable {
    case cards
    case list
}

// MARK: - SectionDirection
public enum DirectionType: String, Codable {
    case vertical
    case horizontal
}

// MARK: - Decodable
extension VFGMoreSectionModel: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        directionType = try? values.decode(DirectionType.self, forKey: .directionType)
        sectionType = try? values.decode(SectionType.self, forKey: .sectionType)
        items = try? values.decode([VFGMoreItemModel].self, forKey: .items)
    }
}

// MARK: - Encodable
extension VFGMoreSectionModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(sectionType, forKey: .sectionType)
        try? container.encode(directionType, forKey: .directionType)
        try? container.encode(items, forKey: .items)
    }
}

/// VFGMoreItemModel  model
public struct VFGMoreItemModel: Codable {
    public var title: String?
    public var icon: String?
    public var badge: Int?

    // MARK: - init
    public init(
        title: String,
        icon: String,
        badge: Int
    ) {
        self.title = title
        self.icon = icon
        self.badge = badge
    }
}
