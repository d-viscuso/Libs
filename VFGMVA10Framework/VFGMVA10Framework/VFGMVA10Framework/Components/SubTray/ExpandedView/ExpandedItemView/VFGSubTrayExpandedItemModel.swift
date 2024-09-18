//
//  VFGSubTrayExpandedItemModel.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 22/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Sub tray expanded view item model
public struct VFGSubTrayExpandedItemModel: Codable {
    /// Expanded view item title
    public var title: String
    /// Expanded view item description
    public var description: String
    /// *VFGSubTrayExpandedItemModel* empty initializer
    init() {
        title = ""
        description = ""
    }
    /// *VFGSubTrayExpandedItemModel* initializer
    /// - Parameters:
    ///    - title: Expanded view item title
    ///    - description: Expanded view item description
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

extension VFGSubTrayExpandedItemModel: Equatable {
    /// Sub tray expanded view items comparison
    public static func == (lhs: VFGSubTrayExpandedItemModel, rhs: VFGSubTrayExpandedItemModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.description == rhs.description
    }
}
