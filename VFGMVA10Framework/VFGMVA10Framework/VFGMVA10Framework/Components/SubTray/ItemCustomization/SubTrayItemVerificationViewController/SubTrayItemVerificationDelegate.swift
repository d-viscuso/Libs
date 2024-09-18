//
//  SubTrayItemVerificationDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Delegation protocol for *SubTrayCustomizationManager* actions
protocol SubTrayItemVerificationDelegate: AnyObject {
    /// Check if entered pin code is valid or not
    /// - Parameters:
    ///    - code: Entered pin code
    /// - Returns: True if entered pin code is valid and false if not
    func checkPinCodeValidation(with code: String) -> Bool
}
