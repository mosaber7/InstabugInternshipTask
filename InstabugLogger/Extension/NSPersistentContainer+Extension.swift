//
//  NSPersistentContainer+Extension.swift
//  InstabugLogger
//
//  Created by Saber on 27/05/2021.
//

import CoreData

public extension NSPersistentContainer {

  func destroyPersistentStore() {
    guard let storeURL = persistentStoreDescriptions.first?.url,
          let storeType = persistentStoreDescriptions.first?.type else {
      return
    }

    do {
      let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
      try persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: storeType, options: nil)
    } catch let error {
      print("failed to destroy persistent store at \(storeURL), error: \(error)")
    }
  }
}

