//
//  Validator.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Gamal on 03/06/2019.
//

import Foundation

enum Valid: Equatable {
    case progress
    case success
}

enum ValidatorType {
    case credential
}

class VFGLoginValidator {
    // MARK: Validator constants
    let pswMinLength = 8

    func validate(value: (type: ValidatorType, inputValue: LoginCredential)) -> Valid {
        var toReturn: Valid = .progress

        switch value.type {
        case .credential:
            if let tempValue = isValidCredential(value.inputValue) {
                toReturn = tempValue
            }
        }
        return toReturn
    }

    func isValidCredential(_ credential: LoginCredential) -> Valid? {
        guard let username = credential.username,
            let password = credential.password else {
                return .progress
        }
        let containsWhitespace = username.containsWhitespace || password.containsWhitespace
        let isEmpty = username.isEmpty || password.isEmpty
        let passwordTooShort = password.tooShortText(pswMinLength)

        if containsWhitespace || isEmpty || passwordTooShort {
            return .progress
        } else {
            return .success
        }
    }
}
