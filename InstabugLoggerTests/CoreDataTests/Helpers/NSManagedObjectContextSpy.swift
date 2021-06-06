//
//  NSManagedObjectContextSpy.swift
//  InstabugLoggerTests
//
//  Created by Saber on 27/05/2021.
//

import CoreData
import XCTest

class NSManagedObjectContextSpy: NSManagedObjectContext {
    var expectation: XCTestExpectation?

        var saveWasCalled = false

        // MARK: - Perform

        override func performAndWait(_ block: () -> Void) {
            super.performAndWait(block)

            expectation?.fulfill()
        }

        // MARK: - Save

        override func save() throws {
            try super.save()

            saveWasCalled = true
        }
}
