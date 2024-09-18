//
//  LogoCardModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 25/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A struct which represents the model for logo card view.
public struct LogoCardModel: Codable {
    public var logo: String?
    public var title: String?
    public var titleColor: String?

    public init (
        logo: String? = nil,
        title: String? = nil,
        titleColor: String? = nil
    ) {
        self.logo = logo
        self.title = title
        self.titleColor = titleColor
    }
}
