//
//  CoreDataStack.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Zaki on 17/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import CoreData

class VFGStorageCoreDataStack {
    var storageName = "StorageModel"
    lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.foundation.url(forResource: storageName, withExtension: "momd") else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let cont: NSPersistentContainer
        if let managedObjectModel = managedObjectModel {
            cont = NSPersistentContainer(name: storageName, managedObjectModel: managedObjectModel)
        } else {
            cont = NSPersistentContainer(name: storageName)
        }
        cont.loadPersistentStores { _, error in
            if let error = error {
                VFGErrorLog("Unresolved error \(error)")
            }
        }
        return cont
    }()

// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
}
