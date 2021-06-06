//
//  Log+CoreDataProperties.swift
//  InstabugLogger
//
//  Created by Saber on 27/05/2021.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var logLevel: Int16
    @NSManaged public var message: String
    @NSManaged public var timeStamp: Date

}

extension Log : Identifiable {

}
