//
//  AuthTokenProvider.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 10/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public typealias Success = ([String: String]?, Error?) -> Void

/// A protocol which is used by the network layer to use the authentication token when needed.
public protocol AuthTokenProvider {
    /// A method used to request authentication token.
    func requestAuthToken(closure: @escaping Success)
}
