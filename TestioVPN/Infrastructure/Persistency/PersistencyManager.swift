//
//  CoreDataStack.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import CoreData

class PersistencyManager {

    private let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    init() {
        let container = NSPersistentContainer(name: "TestioVPN")
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                assertionFailure("Could not load persistent stores \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
