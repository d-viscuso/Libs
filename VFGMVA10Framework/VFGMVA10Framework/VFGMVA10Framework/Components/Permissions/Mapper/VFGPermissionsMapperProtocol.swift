//
//  VFGPermissionsMapperProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 16/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Permissions mapper protocol.
public protocol VFGPermissionsMapperProtocol {
    /// Responsible for creating permissions list for permission step in onBoarding.
    func createPermissions(from config: [Any]?, with customPermissions: [VFGPermissionProtocol]) -> [VFGPermission]
}
