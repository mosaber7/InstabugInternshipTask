//
//  CoreDataTestStack.swift
//  InstabugLoggerTests
//
//  Created by Saber on 27/05/2021.
//

import CoreData

class CoreDataTestStack {
    let managedObjectModel: NSManagedObjectModel
    let container: NSPersistentContainer
        let backgroundContext: NSManagedObjectContextSpy
        let mainContext: NSManagedObjectContextSpy

        init() {
            let frameworkBundleIdentifier = "com.Instabug.InstabugTask"
            let customKitBundle = Bundle(identifier: frameworkBundleIdentifier)!
            let modelURL = customKitBundle.url(forResource: "Log",
                                               withExtension: "momd")!
            managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
            container = NSPersistentContainer(name: "Log", managedObjectModel: managedObjectModel)
            let description = container.persistentStoreDescriptions.first
            description?.type = NSInMemoryStoreType

            container.loadPersistentStores {_, error in
                guard error == nil else {
                    fatalError("was unable to load store \(error!)")
                }
            }

            mainContext = NSManagedObjectContextSpy(concurrencyType: .mainQueueConcurrencyType)
            mainContext.automaticallyMergesChangesFromParent = true
            mainContext.persistentStoreCoordinator = container.persistentStoreCoordinator

            backgroundContext = NSManagedObjectContextSpy(concurrencyType: .privateQueueConcurrencyType)
            backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            backgroundContext.parent = self.mainContext
        }
}
