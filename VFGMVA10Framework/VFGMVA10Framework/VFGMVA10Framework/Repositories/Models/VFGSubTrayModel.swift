//
//  VFGSubTrayModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 08/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//
/// Sub tray view data model
public struct VFGSubTrayModel: Codable {
    /// Sub tray title
    public var title: String?
    /// Array list of sub tray items
    public var items: [VFGSubTrayItem]?
    /// Dictionary for sub tray data
    public var metaData: [String: Any]? = [:]

    enum CodingKeys: String, CodingKey {
        case title
        case items = "subTrayItems"
        case metaData
    }
    /// *VFGSubTrayModel* initializer
    /// - Parameters:
    ///    - title: Sub tray title
    ///    - items: Array list of sub tray items
    ///    - metaData: Dictionary for sub tray data
    public init(
        title: String?,
        items: [VFGSubTrayItem]?,
        metaData: [String: Any]
    ) {
        self.title = title
        self.items = items
        self.metaData = metaData
    }
    /// *VFGSubTrayModel* initializer
    /// Decode a value of the given type for the given key
    /// - Parameters:
    ///    - decoder: A type to decode values from *CodingKeys*
    /// - Throws: Error if failed
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try? container.decode(String.self, forKey: .title)
        items = try? container.decode([VFGSubTrayItem].self, forKey: .items)
        metaData = try? container.decode([String: Any].self, forKey: .metaData)
    }
    /// Encode the given value for the given key
    /// - Parameters:
    ///    - encoder: A type to encode values into *CodingKeys*
    /// - Throws: Error if failed
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.items, forKey: .items)
        try container.encode(of: self.metaData ?? [:], forKey: .metaData)
    }
}
