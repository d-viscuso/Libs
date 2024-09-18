//
//  Optional+Default.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

extension Int: DefaultValue {
    /// Creates default value for the *Int* struct and it is '0' .
    public static var defaultValue: Int { return 0 }
}

extension Double: DefaultValue {
    /// Creates default value for the *Double* struct and it is '0.0' .
    public static var defaultValue: Double { return 0.0 }
}

extension Float: DefaultValue {
    /// Creates default value for the *Float* struct and it is '0.0' .
    public static var defaultValue: Float { return 0.0 }
}

extension String: DefaultValue {
    /// Creates default value for the *String* struct and it is "".
    public static var defaultValue: String { return "" }
}

extension Bool: DefaultValue {
    /// Creates default value for the *Bool* struct and it is false.
    public static var defaultValue: Bool { return false }
}

extension Array: DefaultValue {
    /// Creates default value for the *Array* struct and it is [].
    public static var defaultValue: [Element] { return [] }
}
