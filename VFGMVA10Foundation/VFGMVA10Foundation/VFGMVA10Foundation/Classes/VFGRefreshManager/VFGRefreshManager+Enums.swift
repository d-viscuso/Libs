//
//  VFGRefreshManager+Enums.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 05/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGRefreshManager {
    /// An enum that represent time format in hours or date
    public enum TimeFormat {
        case hours
        case date
    }
}

/// An enum that represent refresh status
public enum VFGRefreshStatus: Equatable {
    case updating
    case justUpdated
    case minute(Int)
    case minutes(Int)
    case timeStamp(String)
}
