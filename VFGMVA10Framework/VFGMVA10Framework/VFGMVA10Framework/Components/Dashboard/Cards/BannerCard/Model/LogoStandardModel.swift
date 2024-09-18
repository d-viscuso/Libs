//
//  LogoStandardModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 03/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

public struct LogoStandardModel: Codable {
    public var logo: String?
    public var title: String?
    public var subtitle: String?
    public var titleColor: String?
    public var subtitleColor: String?

    public init (
        logo: String? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        titleColor: String? = nil,
        subtitleColor: String? = nil
    ) {
        self.logo = logo
        self.title = title
        self.subtitle = subtitle
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
    }
}
