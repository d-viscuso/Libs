//
//  OAuth2Authentication.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 7/25/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

typealias AuthenticationManagerCompletion = (_ token: Token?, _ error: Error?) -> Void
/// A protocol which is used internally with OAuth2Authentication class.
protocol AuthenticationManagerProtocol {
    /// A method used to get new access token.
    func getToken(closure: @escaping AuthenticationManagerCompletion)
    /// A method used to refresh current access token.
    func refreshToken(closure: @escaping AuthenticationManagerCompletion)
}
