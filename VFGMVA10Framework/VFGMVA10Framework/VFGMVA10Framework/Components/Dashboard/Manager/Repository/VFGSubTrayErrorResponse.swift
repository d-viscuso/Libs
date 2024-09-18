//
//  VFGSubTrayErrorResponse.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
/// Error types for sub tray
public enum VFGSubTrayErrorResponse: Error, LocalizedError {
    case network(String)
    case transition
    /// Error description configuration
    public var errorDescription: String? {
        switch self {
        case .network(let subTrayTitle):
            let subTrayTitle = String("\n\(subTrayTitle.localized(bundle: .mva10Framework))")
            return String(format: "sub_tray_error_title".localized(bundle: .mva10Framework), arguments: [subTrayTitle])
        case .transition:
            return "Transition failed"
        }
    }
}
