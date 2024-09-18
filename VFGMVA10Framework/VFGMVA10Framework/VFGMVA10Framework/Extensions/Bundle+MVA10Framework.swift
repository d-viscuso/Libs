//
//  Bundle+MVA10Framework.swift
//  VFGMVA10Group
//
//  Created by ahmed mahdy on 9/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension Bundle {
    /// Framework bundle.
    public static var mva10Framework: Bundle {
        return Bundle(for: VFPermissionsView.self)
    }
}
