//
//  TilesModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 09/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public struct TileModel: Codable, Equatable {
    public var id: String
    public var title: String
    public var icon: String

    public init(
        id: String,
        title: String,
        icon: String
    ) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}
