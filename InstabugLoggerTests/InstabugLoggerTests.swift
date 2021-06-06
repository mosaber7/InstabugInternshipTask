//
//  InstabugLoggerTests.swift
//  InstabugLoggerTests
//
//  Created by Yosef Hamza on 19/04/2021.
//

import XCTest
import CoreData

@testable import InstabugLogger

class InstabugLoggerTests: XCTestCase {
    var sut: InstabugLogger!
    
    override func setUpWithError() throws {
        sut = InstabugLogger.shared
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
}
