//
//  VFGCache.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 25/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// `VFGCache` is a wrapper class for the regular NSCache but with more flexible interface.
/// - You should provide type of the object within decleration.
/// - It takes a generic object of type AnyObject.
public class VFGCache<T: AnyObject> {
    var cache: NSCache<NSString, T>
    var metaData: [String: [String: String]]

    /// Initialize the VFGCache class.
    init() {
        cache = NSCache<NSString, T>()
        metaData = [:]
    }

    /// Caches the given object and it's meta data (if it is provided) by the given key.
    /// - Parameters:
    ///    - obj: The object that would be cached.
    ///    - key: Key for the cached object, note that this key must not be changed for the same object
    ///     (ie: if you want to retrive the cashed object you must provide the same key you used to save it).
    ///    - metaData: Meta data for the corresponding object, it is nil by default.
    public func save(_ obj: T, forKey key: String, metaData: [String: String]?) {
        cache.setObject(obj, forKey: NSString(string: key))
        self.metaData[key] = metaData
    }

    /// Retrieves the cached object.
    /// - Parameters:
    ///    - key: Key for the cached object, note that this key must be  the same key you used to save the object.
    /// - Returns: A *Tuble* contains optional value of the cached object and it's meta data.
    public func retrieve(from key: String) -> (object: T?, metaData: [String: String]?) {
        (object: cache.object(forKey: NSString(string: key)), metaData: metaData[key])
    }

    /// Removes the cached object.
    /// - Parameters:
    ///    - key: Key for the cached object, note that this key must be  the same key you used to save the object.
    public func remove(with key: String) {
        cache.removeObject(forKey: NSString(string: key))
    }
}
