//
//  VFGTrayModel.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Mahmoud Zaki on 12/20/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Main tray data model
public struct VFGTrayModel: Codable {
    /// Array list of main tray item model
    public var items: [VFGTrayItemModel]?

    init() {
        items = nil
    }

    enum CodingKeys: String, CodingKey {
        case items = "trayItems"
    }
}
