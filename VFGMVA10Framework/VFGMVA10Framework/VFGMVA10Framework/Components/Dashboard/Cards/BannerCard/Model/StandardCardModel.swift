//
//  StandardCardModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 25/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A struct which represents the model for standard card view.
public struct StandardCardModel: Codable {
    public var title: String?
    public var subtitle: String?
    public var titleColor: String?
    public var subtitleColor: String?

    public init (
        title: String? = nil,
        subtitle: String? = nil,
        titleColor: String? = nil,
        subtitleColor: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
    }
}
