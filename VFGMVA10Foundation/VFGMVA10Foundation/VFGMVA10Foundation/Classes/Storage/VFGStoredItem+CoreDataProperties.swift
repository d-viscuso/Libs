//
//  VFGStoredItem+CoreDataProperties.swift
//  
//
//  Created by Mohamed Zaki on 18/02/2021.
//
//

import Foundation
import CoreData


extension VFGStoredItem {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<VFGStoredItem> {
        return NSFetchRequest<VFGStoredItem>(entityName: "VFGStoredItem")
    }

    @NSManaged public var key: String?
    @NSManaged public var lifetime: Double
    @NSManaged public var priority: Int64
    @NSManaged public var shouldExtendTimeIfAccessed: Bool
    @NSManaged public var timer: Double
    @NSManaged public var storedItemData: VFGStoredItemData?
}
