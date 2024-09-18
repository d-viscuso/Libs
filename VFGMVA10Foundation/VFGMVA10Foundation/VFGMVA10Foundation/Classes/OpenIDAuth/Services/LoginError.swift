//
//  LoginError.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Gamal on 11/06/2019.
//

import Foundation

enum ErrorMessage: String {
    case credentialErrorTitle = "userName_Password_incorrect"
    case credentialErrorMessage = "please_Try_again"
    case genericErrorTitle = "something_Went_wrong"
    case genericErrorMessage = "please_Try_again_later"
    func localized() -> String {
        return VFGContentManager.shared.value(for: self.rawValue)
    }
}

enum VFGLoginError: String {
    typealias RawValue = String
    case unauthorized = "Unauthorized"
    case invalidRequest = "invalid_request"
    case invalidClient = "invalid_client"
    case invalidGrant = "invalid_grant"
    case unauthorizedClient = "unauthorized_client"
    case unsupportedGrantType = "unsupported_grant_type"
    case invalidScope = "invalid_scope"
    case defaultError = "default"

    var errorTitle: ErrorMessage {
        switch self {
        case
            .unauthorized,
            .invalidRequest,
            .invalidClient,
            .unauthorizedClient,
            .unsupportedGrantType,
            .invalidScope:
            return ErrorMessage.genericErrorTitle
        case .invalidGrant:
            return ErrorMessage.credentialErrorTitle
        case .defaultError:
            return ErrorMessage.genericErrorTitle
        }
    }

    var errorMessage: ErrorMessage {
        switch self {
        case
            .unauthorized,
            .invalidRequest,
            .invalidClient,
            .unauthorizedClient,
            .unsupportedGrantType,
            .invalidScope:
            return ErrorMessage.genericErrorMessage
        case .invalidGrant:
            return ErrorMessage.credentialErrorMessage
        case .defaultError:
            return ErrorMessage.genericErrorMessage
        }
    }
}
