//
//  CoreDataManger.swift
//  InstabugLogger
//
//  Created by Saber on 26/05/2021.
//

import CoreData

public class CoreDataManager {
    static let shared = CoreDataManager()
    // defines the storage type of the CoreData
    private var storeType: String!
    
    // MARK: - CoreData stack configuration
    
    // MARK: - STEP 1 create the persistent container
    lazy var persistentContainer: NSPersistentContainer! = {
        let container = NSPersistentContainer(name: "Log")
        let description = container.persistentStoreDescriptions.first
        description?.type = storeType ?? NSSQLiteStoreType
        container.loadPersistentStores {(_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    // MARK: - STEP 2: create the object model
    lazy var managedObjectModel: NSManagedObjectModel = {
        let frameworkBundle = Bundle(identifier: "com.Instabug.InstabugTask")!
        let modelURL = frameworkBundle.url(forResource: "Log",
                                           withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    // MARK: - STEP 3: create the main context & background context
    
    //  the background context
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }()
    // the main context for testing
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    func setup(storeType: String = NSSQLiteStoreType) {
      self.storeType = storeType
    }

    private func loadPersistentStore(completion: @escaping () -> Void) {
         // handle data migration on a different thread/queue here
         persistentContainer.loadPersistentStores {_, error in
             guard error == nil else {
                 fatalError("was unable to load store \(error!)")
             }

             completion()
         }
     }
}
