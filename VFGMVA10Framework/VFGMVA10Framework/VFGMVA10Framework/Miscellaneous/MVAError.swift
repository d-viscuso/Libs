//
//  MVAError.swift
//  mva10
//
//  Created by Sandra Morcos on 12/17/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation
/// App errors types
public enum MVAError: Error {
    /// Parse
    case parse
    /// Network
    case network
    /// Empty
    case empty
    /// Error message description based on error type
    var localizedDescription: String {
        switch self {
        case .parse:
            return "Parsing Failed"
        case .network:
            return "Network Error"
        case .empty:
            return "No data"
        }
    }
}
