//
//  UserGuides.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 22/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation

/// A struct model which holds user guide pages and the initial page.
public struct UserGuides: Equatable {
    var identifier: String?
    let initialPage: String
    let pages: [String: UserGuidesPage]

    enum CodingKeys: String, CodingKey {
        case identifier
        case initialPage
        case pages
    }

    /// User guides struct initializer
    /// - Parameters:
    ///   - initialPage: A string object represents the initial page from where the user guides would start.
    ///   - pages: A dictionary which holds the pages that would be shown as a steps.
    public init(initialPage: String, pages: [String: UserGuidesPage]) {
        self.initialPage = initialPage
        self.pages = pages
    }

    /// Checks for equality.
    public static func == (lhs: UserGuides, rhs: UserGuides) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.initialPage == rhs.initialPage
    }
}
