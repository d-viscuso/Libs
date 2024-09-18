//
//  String+Validations.swift
//  VFGMVA10Group
//
//  Created by Mohamed Abd ElNasser on 7/29/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension String {
    func isInt() -> Bool {
        return Int(self) != nil
    }

    func isValidEmailFormat() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
