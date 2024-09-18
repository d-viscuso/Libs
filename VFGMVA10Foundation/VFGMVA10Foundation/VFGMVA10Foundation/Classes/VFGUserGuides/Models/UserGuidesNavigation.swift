//
//  UserGuidesNavigation.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 22/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation

/// A class model which holds user guides navigation data.
public final class UserGuidesNavigation: Equatable {
    /// A string enum which is used to handle user guides navigation button style
    public enum Kind: String {
        case userguides
        case app
    }

    enum CodingKeys: String, CodingKey {
        case type
        case title
    }

    let type: Kind
    let navigationTitle: String
    let navigationId: String

    /// User guides navigation class initializer.
    /// - Parameters:
    ///   - title: A string object which represents the navigation title.
    ///   - identifier: A string object which represents the navigation identifier.
    ///   - type: An enum of type *Kind* which is used to the button style.
    public init(title: String, identifier: String, type: Kind) {
        self.navigationTitle = title
        self.navigationId = identifier
        self.type = type
    }

    /// Checks for equality.
    public static func == (lhs: UserGuidesNavigation, rhs: UserGuidesNavigation) -> Bool {
        return lhs.navigationId == rhs.navigationId && lhs.navigationTitle == rhs.navigationTitle
    }
}

extension UserGuidesNavigation.Kind {
    /// An object of type *VFGButton.ButtonStyle* which returns `.primary` if the type is `.app` and `.userguides`if the type is `.userguides`.``
    public var buttonStyle: VFGButton.ButtonStyle {
        switch self {
        case .app:
            return VFGButton.ButtonStyle.primary
        case .userguides:
            return VFGButton.ButtonStyle.secondary
        }
    }
}
