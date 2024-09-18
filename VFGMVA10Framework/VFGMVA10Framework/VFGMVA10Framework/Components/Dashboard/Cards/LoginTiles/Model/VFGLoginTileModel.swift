//
//  VFGLoginTileModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 08/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A struct model which represents a login tile data.
public struct VFGLoginTileModel: Codable, Equatable {
    public let title: String
    public let description: String
    public let ctaTitle: String
}
