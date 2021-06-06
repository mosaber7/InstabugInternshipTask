//
//  InstabugLogger.swift
//  InstabugLogger
//
//  Created by Yosef Hamza on 19/04/2021.
//

import CoreData

public class InstabugLogger {
    public static var shared = InstabugLogger()
    private let dataManager: DatabaseProtocol = LoggerCoreDataManager()
     init() {
    // Cleans disk store on every app launch.
        dataManager.removeAllLogs()
    }
    // MARK:- Logging
    public func log(_ level: LogLevel, message: String) {
        dataManager.saveLog(message: message, logLevel: level)
    }
    // MARK:- Fetching
    // fetches and returns an array of Log from the database
    public func fetchAllLogs() -> [Log] {
        return dataManager.fetchAllLogs()
    }
    
    // fetches and returns an array of Log from the database in a closure
    public func fetchAllLogs(completionHandler: ([Log])->Void) {
        completionHandler(dataManager.fetchAllLogs())
    }
}
