//
//  LanguageModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 01/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// A language model that contains the language name, imageName, identifier, isCurrentLanguage
public struct LanguageModel: Decodable {
    /// language name
    public var name: String
    /// language icon imageName
    public let imageName: String
    /// language identifier
    public let identifier: String
    /// a boolean to set a language as current language or not
    public var isCurrentLanguage: Bool?

    /// Initializer
    /// - Parameters:
    ///   - name: language name
    ///   - imageName: language icon imageName
    ///   - identifier: language identifier
    ///   - isCurrentLanguage: a boolean to set a language as current language or not
    public init(name: String, imageName: String, identifier: String, isCurrentLanguage: Bool = false) {
        self.name = name.localized()
        self.imageName = imageName
        self.identifier = identifier
        self.isCurrentLanguage = isCurrentLanguage
    }

    enum CodingKeys: String, CodingKey {
        case name
        case imageName
        case identifier
        case isCurrentLanguage
    }

    /// Initializer
    /// - Parameters:
    ///   - from: Decoder to set anguage model from fetched data
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = (try container.decode(String.self, forKey: .name)).localized()
        imageName = try container.decode(String.self, forKey: .imageName)
        identifier = try container.decode(String.self, forKey: .identifier)
        isCurrentLanguage = try? container.decode(Bool.self, forKey: .isCurrentLanguage)
    }

    /// setCurrentLanguage
    /// - Parameters:
    ///   - currentIdentifier: current language  Identifier
    public mutating func setCurrentLanguage(currentIdentifier: String) {
        isCurrentLanguage = identifier == currentIdentifier
    }
}
