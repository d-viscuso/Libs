//
//  PropertyStoring.swift
//  VFGMVA10Foundation
//
//  Created by Sandra Morcos on 6/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public protocol PropertyStoring {
    associatedtype ObjectType
    /**
    - Get an object associated to the given key.

    - Parameter key: UnsafeRawPointer!: A key which is the pointer associated with the object.
    - Returns: the value associated with a given object for a given key.
    */
    func getAssociatedObject(_ key: UnsafeRawPointer!) -> ObjectType?

    /**
    - Allow storing an object with an associated key.

    - Parameter key: UnsafeRawPointer!: A key which is the pointer associated with the object.
    - Parameter object: The source object for the association.
    */
    func setAssociatedObject(_ key: UnsafeRawPointer!, newValue: ObjectType?)
}

extension PropertyStoring {
    public func getAssociatedObject(_ key: UnsafeRawPointer!) -> ObjectType? {
        guard let value = objc_getAssociatedObject(self, key) as? ObjectType else {
            return nil
        }
        return value
    }

    public func setAssociatedObject(_ key: UnsafeRawPointer!, newValue: ObjectType?) {
        objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
}
