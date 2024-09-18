//
//  Double+Decimals.swift
//  VFGMVA10
//
//  Created by Mahmoud Amer on 1/13/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    /// A method used to return truncating reminder.
    /// - Returns: The remainder of this value divided by 1 using truncating division.
    public func decimalPart() -> Double {
        return truncatingRemainder(dividingBy: 1)
    }
}
