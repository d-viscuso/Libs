//
//  VFGStoredItemData+CoreDataProperties.swift
//  
//
//  Created by Mohamed Zaki on 18/02/2021.
//
//

import Foundation
import CoreData


extension VFGStoredItemData {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<VFGStoredItemData> {
        return NSFetchRequest<VFGStoredItemData>(entityName: "VFGStoredItemData")
    }

    @NSManaged public var data: Data?
    @NSManaged public var storedItem: VFGStoredItem?
}
