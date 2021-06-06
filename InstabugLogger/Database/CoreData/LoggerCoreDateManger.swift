//
//  LoggerCoreDateManger.swift
//  InstabugLogger
//
//  Created by Saber on 26/05/2021.
//

import CoreData

class LoggerCoreDataManager {
    let logsLimitPerSession = 1_000
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    init(mainContext: NSManagedObjectContext =
            CoreDataManager.shared.mainContext,
         backgroundContext: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
}

extension LoggerCoreDataManager: DatabaseProtocol{
    // MARK:- DatabaseProtocol Methods
    
    // deletes all logs from CoreData
    func removeAllLogs() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Log")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        backgroundContext.performAndWait {
            _ = try? backgroundContext.execute(deleteRequest)
            try? backgroundContext.save()
        }
    }
    /// - Returns: all of the current session's logs as a `Log` array.
    func fetchAllLogs() -> [Log] {
        let fetchReq = NSFetchRequest<Log>(entityName: "Log")
        let sortByDate = NSSortDescriptor(key: "timeStamp", ascending: true)
        fetchReq.sortDescriptors = [sortByDate]
        fetchReq.returnsObjectsAsFaults = false
        var logs = [Log]()
        mainContext.performAndWait {
            do {
                logs = try mainContext.fetch(fetchReq)
            } catch {
                print("failed to fetch from the database")
            }
        }
        return logs
    }
    // Creates a `Log` from `message` and `logLevel` and save it
    func saveLog(message: String, logLevel: LogLevel) {
        let logs = fetchAllLogs()
            self.backgroundContext.performAndWait {
            if logs.count >= self.logsLimitPerSession {
            let firstLog = logs[0]
            let objectID = firstLog.objectID

                if let logInContext = try? self.backgroundContext.existingObject(with: objectID) {
                    self.backgroundContext.delete(logInContext)
            }
          }
          let log =
            NSEntityDescription.insertNewObject(forEntityName: "Log", into: self.backgroundContext) as! Log
                log.config(message: message, logLevel: logLevel)

          do {
            try self.backgroundContext.save()
          } catch let error {
            fatalError("\(error)")
        }
        }
        
    }
    // MARK:- Helper Methods
    // removes a specific log
     func remove(log: Log) {
        let logID = log.objectID
        backgroundContext.performAndWait {
            if let logInContext = try? backgroundContext.existingObject(with: logID) {
                backgroundContext.delete(logInContext)
                try? backgroundContext.save()
            }
        }
    }
    // sorts logs ascendingly by timestamp and remove the first log (the oldest)
     func removeFirstLog() {
        let fetchRequest = NSFetchRequest<Log>(entityName: "Log")
        let sortByTimestamp = NSSortDescriptor(key: "timeStamp", ascending: true)
        fetchRequest.sortDescriptors = [sortByTimestamp]
        fetchRequest.fetchLimit = 1
        let logs = try! backgroundContext.fetch(fetchRequest)
        let oldestLog = logs[0]
        remove(log: oldestLog)
    }
}


