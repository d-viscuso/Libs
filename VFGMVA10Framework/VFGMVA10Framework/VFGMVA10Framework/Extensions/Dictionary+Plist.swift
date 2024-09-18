//
//  Dictionary+Plist.swift
//  VFGMVA10Group
//
//  Created by Hussien Gamal Mohammed on 7/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    static func savePropertyList(_ plist: Any, with fileName: String) throws {
        guard let documentDirectoryURL = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false) else {
                return
        }
        let plistURL = documentDirectoryURL.appendingPathComponent(fileName)
        let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try plistData.write(to: plistURL)
    }

    static func loadPropertyList(fileName: String, create: Bool = false) throws -> [String: Any] {
        guard let documentDirectoryURL = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: create) else { return [:] }
        let plistURL = documentDirectoryURL.appendingPathComponent(fileName)
        let data = try Data(contentsOf: plistURL)
        guard let plist = try PropertyListSerialization.propertyList(
            from: data,
            format: nil) as? [String: Any] else {
                return [String: String]()
        }
        return plist
    }

    static func deletePlist(fileName: String) throws {
        guard let documentDirectoryURL = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false) else { return }
        let plistURL = documentDirectoryURL.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: plistURL)
    }
}
