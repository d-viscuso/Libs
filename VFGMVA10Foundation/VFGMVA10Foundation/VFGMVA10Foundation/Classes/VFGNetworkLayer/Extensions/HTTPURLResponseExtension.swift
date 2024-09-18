//
//  HTTPURLResponseExtension.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 10/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// An extension of *HTTPURLResponse* which represents a response to an HTTP URL load. It is a specialization of NSURLResponse which provides conveniences for accessing information specific to HTTP protocol responses.
extension HTTPURLResponse: HTTPURLResponseProtocol {
    /// A method used to HTTP response status codes indicate whether a specific HTTP request has been successfully completed.
    /// - Returns: An enum of type *VFGNetworkError* which holds an error message corresponds to specific response.
    public func handleNetworkResponse() -> VFGNetworkError? {
        switch self.statusCode {
        case 200...299: return nil
        case 400:       return VFGNetworkError.serverBadRequest
        case 401...499: return VFGNetworkError.serverAuthenticationError
        case 500...599: return VFGNetworkError.serverError
        case 600: return VFGNetworkError.serverOutdated
        default: return VFGNetworkError.serverFailed
        }
    }
}
