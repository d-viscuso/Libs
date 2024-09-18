//
//  NetworkError.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 10/15/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// An string enum which holds an error message corresponds to specific response.
public enum VFGNetworkError: String, Error {
    case parse      = "Unable to parse response"
    case network    = "Network operation failed"
    case empty      = "Empty response"
    case missingURL = "missing URL"
    case encodingFailed = "encodingFailed"
    case unknown    = "Unknown"
    case authFailed = "Authentication token missed"
    case noInternetConnection = "no Internet Connection"
    case serverAuthenticationError = "You need to be authenticated first."
    case serverBadRequest = "Bad request"
    case serverError = "server encountered an unexpected condition"
    case serverOutdated = "The url you requested is outdated."
    case serverFailed = "Network request failed."
    case serverNoData = "Response returned with no data to decode."
    case serverUnableToDecode = "We could not decode the response."
}
