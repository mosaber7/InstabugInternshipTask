//
//  Log+CoreDataClass.swift
//  InstabugLogger
//
//  Created by Saber on 27/05/2021.
//
//

import Foundation
import CoreData

@objc(Log)
public class Log: NSManagedObject {
    // configure and intialize the log Model.
    func config(message: String, logLevel: LogLevel){
        self.message = message
        self.timeStamp = Date()
        self.logLevel = logLevel.rawValue
    }
}

extension Log: Comparable{
    public static func < (lhs: Log, rhs: Log) -> Bool {
       return lhs.timeStamp < rhs.timeStamp
    }
}
