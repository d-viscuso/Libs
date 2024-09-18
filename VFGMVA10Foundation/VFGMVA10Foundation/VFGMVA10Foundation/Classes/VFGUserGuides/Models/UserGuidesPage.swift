//
//  UserGuidesPage.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 22/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation

/// A class model which holds the data of user guide specific step.
public final class UserGuidesPage: Equatable {
    enum DecodingKeys: String {
        case title
        case subtitle
        case image
        case description
        case navigation
    }

    let pageId: String
    let title: String
    let subtitle: String
    let imageURL: URL?
    let imageDescription: String?
    let details: String?
    let navigation: UserGuidesNavigation

    /// User guides navigation class initializer.
    /// - Parameters:
    ///   - pageId: A string object which represents the step id.
    ///   - title: A string object whcih represents the step title.
    ///   - subtitle: A string object which represents the step subtitle that is shown below step title.
    ///   - imageURL: An object of type *URL* that represents the step url image that is shown below step subtitle.
    ///   - imageDescription: Image description for voice over accessibility.
    ///   - details: A string object which represents the step description that is shown below step image.
    ///   - navigation: An object of type *UserGuidesNavigation* which represents the step button title that is shown at the bottom of the component.
    public init(
        pageId: String,
        title: String,
        subtitle: String,
        imageURL: URL? = nil,
        imageDescription: String? = nil,
        details: String? = nil,
        navigation: UserGuidesNavigation
    ) {
        self.pageId = pageId
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.imageDescription = imageDescription
        self.details = details
        self.navigation = navigation
    }

    /// Checks for equality.
    public static func == (lhs: UserGuidesPage, rhs: UserGuidesPage) -> Bool {
        return lhs.pageId == rhs.pageId && lhs.title == rhs.title
    }
}
