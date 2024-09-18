//
//  Optional+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// `DefaultValue` is abstract interface to provide default value for the conformed types.
///
/// You can use this protocol to provide default value for Foundation or UIKit types and even your custom types.
public protocol DefaultValue {
    associatedtype DefaultType: DefaultValue where DefaultType.DefaultType == Self
    static var defaultValue: DefaultType { get }
}

public extension Optional where Wrapped: DefaultValue, Wrapped.DefaultType == Wrapped {
    /// Safely returns the wrapped value.
    var required: Wrapped {
        defer {
            if self == nil {
                assertionFailure("Value can not be nil because you try to unwrap value")
            }
        }
        return valueOrDefault
    }

    /// Safely returns the wrapped value (self), if self is nil it will return the default value of self.
    ///
    /// For more information, see **DefaultValue**
    var valueOrDefault: Wrapped {
        guard let notNilSelf = self else {
            return Wrapped.defaultValue
        }
        return notNilSelf
    }
}

public extension Optional {
    /// Returns the wrapped value.
    var required: Wrapped {
        guard let notNilSelf = self else {
            return self!
        }
        return notNilSelf
    }
}

public extension Optional where Wrapped == String {
    /// Boolean value to determine if the optional String is blank or not.
    var isBlank: Bool {
        if let unwrapped = self {
            return unwrapped.isBlank
        } else {
            return true
        }
    }
}
