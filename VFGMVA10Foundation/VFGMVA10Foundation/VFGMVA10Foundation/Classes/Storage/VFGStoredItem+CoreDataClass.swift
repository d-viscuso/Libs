//
//  VFGStoredItem+CoreDataClass.swift
//  
//
//  Created by Mohamed Zaki on 18/02/2021.
//
//

import Foundation
import CoreData

public class VFGStoredItem: NSManagedObject {
    func fillData(data: StoredItemValues) {
        self.key = data.key
        self.storedItemData = data.data
        self.timer = data.timer
        self.lifetime = data.lifetime
        self.priority = Int64(data.priority)
        self.shouldExtendTimeIfAccessed = data.shouldExtendTimeIfAccessed
    }
}

public struct StoredItemValues {
    public let key: String
    public let data: VFGStoredItemData
    public let timer: TimeInterval
    public let lifetime: TimeInterval
    public let priority: Int
    public let shouldExtendTimeIfAccessed: Bool

    public init(
        key: String,
        data: VFGStoredItemData,
        timer: TimeInterval,
        lifetime: TimeInterval,
        priority: Int,
        shouldExtendTimeIfAccessed: Bool
    ) {
        self.key = key
        self.data = data
        self.timer = timer
        self.lifetime = lifetime
        self.priority = priority
        self.shouldExtendTimeIfAccessed = shouldExtendTimeIfAccessed
    }
}
