//
//  VFGContactNumberValidatorProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Zaki on 11/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Contact number validator protocol.
public protocol VFGContactNumberValidatorProtocol {
    /// Value used to check phone number max lenght. if not set, it will not be checked.
    var phoneNumberMaxLenght: Int? { get }
    /// Method used to validates if the number you want to topUp is a real number and can be recharged or not, used when you want to topUp someone else.
    /// - Parameters:
    ///    - text: Someone else's number.
    /// - Returns: Return a *Bool* that represents if the number is valid for topUp or not.
    func validateMobileNumber(text: String) -> Bool
}

public extension VFGContactNumberValidatorProtocol {
    var phoneNumberMaxLenght: Int? {
        nil
    }
}
