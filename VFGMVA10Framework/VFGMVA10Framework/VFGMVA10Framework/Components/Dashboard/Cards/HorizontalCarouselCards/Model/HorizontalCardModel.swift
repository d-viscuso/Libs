//
//  HorizontalCardModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 03/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

/// A struct which represents the model for card type and it's associated data.
public struct HorizontalCardModel: Codable {
    public var id: String?
    public var type: String
    public var data: [String: Any]?

    enum CodingKeys: CodingKey {
        case id
        case type
        case data
    }

    /// Horizontal card model constructor.
    /// - Parameters:
    ///   - id: A  *String* instance which represents
    ///   - type: A  *String* instance which represents the cell name.
    ///   - data: A dictionary which holds data associated with cell type.
    public init(
        id: String? = nil,
        type: String,
        data: [String: Any]? = nil
    ) {
        self.id = id
        self.type = type
        self.data = data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(String.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        self.data = try? container.decode([String: Any].self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.type, forKey: .type)
    }
}
