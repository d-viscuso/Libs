//
//  VFGDashboardItem+MetaData.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 11/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension VFGDashboardItem {
    /// Retrieve data for given key
    /// - Parameters:
    ///    - key: A key to get it value
    /// - Returns: Decoded value for the given key
    public func value(for key: String) -> Codable? {
        switch key {
        case VFGMetaDataKeys.subItems:
            return getSubItems()
        case VFGMetaDataKeys.title:
            return getTitle()
        case VFGMetaDataKeys.moreText:
            return getMoreText()
        case VFGMetaDataKeys.videoURLString:
            return getVidoURLString()
        case VFGMetaDataKeys.config:
            return getConfig()
        case VFGMetaDataKeys.webUrl:
            return getWebUrl()
        case VFGMetaDataKeys.accessibilityTitle:
            return getAccessibilityTitle()
        default:
            return nil
        }
    }
    /// Retrieve Array list of dashboard item dictionary data
    /// - Parameters:
    ///    - start: Array start index
    ///    - end: Array end index
    public mutating func sliceSubItemsArray(from start: Int, to end: Int) {
        if let subItemsDict = metaData?[VFGMetaDataKeys.subItems] as? [VFGSubItem] {
            metaData?[VFGMetaDataKeys.subItems] = Array(subItemsDict[start...end])
        }
        guard let subItemsDict = metaData?[VFGMetaDataKeys.subItems] as? [[String: Any]] else {
            return
        }
        metaData?[VFGMetaDataKeys.subItems] = Array(subItemsDict[start...end])
    }

    private func getSubItems() -> [VFGSubItem]? {
        let decoder = JSONDecoder()
        if let subItems = metaData?[VFGMetaDataKeys.subItems] as? [VFGSubItem] {
            return subItems
        }
        guard let subItemsDict = metaData?[VFGMetaDataKeys.subItems] as? [[String: Any]] else {
            return nil
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: subItemsDict, options: .prettyPrinted)
            let subItems = try decoder.decode([VFGSubItem].self, from: jsonData)
            return subItems
        } catch {
            return nil
        }
    }

    private func getTitle() -> String? {
        return metaData?[VFGMetaDataKeys.title] as? String
    }

    private func getMoreText() -> String? {
        return metaData?[VFGMetaDataKeys.moreText] as? String
    }

    private func getVidoURLString() -> String? {
        return metaData?[VFGMetaDataKeys.videoURLString] as? String
    }

    private func getConfig() -> String? {
        return metaData?[VFGMetaDataKeys.config] as? String
    }

    private func getWebUrl() -> String? {
        return metaData?[VFGMetaDataKeys.webUrl] as? String
    }

    private func getAccessibilityTitle() -> String? {
        return metaData?[VFGMetaDataKeys.accessibilityTitle] as? String
    }
}
