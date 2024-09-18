//
//  DxlConstants.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 3/15/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// A singleton class which holds a default values used in configuring header and parameters of DXL requests.
public class VFGDxlConstants {
    public static let shared = VFGDxlConstants()
    private init() {}

    // constants
    /// The client id.
    public var clientID = ""
    /// The country code.
    public var countryCode = ""
    /// The grant type that refers to the way an application gets an access token.
    /// OAuth 2.0 defines several grant types, including the Password grant.
    /// OAuth 2.0 extensions can also define new grant types.
    public var grantType = "authorization_code"
    /// Indicates which content types, expressed as MIME types, the client is able to understand.
    public var accept = "application/json"
    /// The natural language and locale that the client prefers.
    public var acceptLanguage = "en-GR"
    /// The original media type of the resource.
    public var contentType = "application/json"
}
