//
//  LoggerCoreDataManagerTests.swift
//  InstabugLoggerTests
//
//  Created by Saber on 27/05/2021.
//

import XCTest
import CoreData
@testable import InstabugLogger

class LoggerCoreDataManagerTests: XCTestCase {
    var sut: LoggerCoreDataManager!
    var coreDataStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        sut = LoggerCoreDataManager(mainContext: coreDataStack.mainContext, backgroundContext: coreDataStack.mainContext)
    }
    
    func test_init_contexts() {
        XCTAssertEqual(sut.backgroundContext, coreDataStack.mainContext)
    }
    
    func test_saveLog_LogCreatedANDsaved() {
        sut.saveLog(message: "Test message", logLevel: .INFO)
        
        let fetchReq = NSFetchRequest<Log>(entityName: "Log")
        let logs = try! self.coreDataStack.mainContext.fetch(fetchReq)
        XCTAssertEqual(logs.count,1)
        XCTAssertEqual(logs.first?.message, "Test message")
        XCTAssertEqual(logs.first?.logLevel, LogLevel.INFO.rawValue)

        
    }
    
    func test_removeLog_logRemoved()  {
        let log1 = NSEntityDescription.insertNewObject(forEntityName: "Log",
                                                       into: self.coreDataStack.mainContext) as! Log
        let log2 = NSEntityDescription.insertNewObject(forEntityName: "Log",
                                                       into: self.coreDataStack.mainContext) as! Log
        let log3 = NSEntityDescription.insertNewObject(forEntityName: "Log",
                                                       into: self.coreDataStack.mainContext) as! Log
        
        log1.timeStamp = Date()
        log2.timeStamp = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        log3.timeStamp = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        try! coreDataStack.mainContext.save()
        let performAndWaitExpectation = expectation(description: "background perform and wait")
        coreDataStack.mainContext.expectation = performAndWaitExpectation
        sut.remove(log: log1)
        waitForExpectations(timeout: 1.0) { (_) in
            let fetchReq = NSFetchRequest<Log>(entityName: "Log")
            let logs = try! self.coreDataStack.mainContext.fetch(fetchReq)
            
            XCTAssertEqual(logs.count,2)
            XCTAssertTrue(logs.contains(log2))
            XCTAssertTrue(logs.contains(log3))
            XCTAssertTrue(self.coreDataStack.mainContext.saveWasCalled)
        }
    }
    
    func test_removeFirstLog_firstLogRemoved() {

        let log1 = NSEntityDescription.insertNewObject(forEntityName: "Log", into: self.coreDataStack.mainContext) as! Log
        
        let log2 = NSEntityDescription.insertNewObject(forEntityName: "Log",
                                                       into: self.coreDataStack.mainContext) as! Log
        let log3 = NSEntityDescription.insertNewObject(forEntityName: "Log",
                                                       into: self.coreDataStack.mainContext) as! Log
       
        log1.timeStamp = Date()
        log2.timeStamp = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        log3.timeStamp = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        try! coreDataStack.mainContext.save()
        
        let performAndWaitExpectation = expectation(description: "background perform and wait")
        coreDataStack.mainContext.expectation = performAndWaitExpectation
        sut.removeFirstLog()
        waitForExpectations(timeout: 1.0) { (_) in
            let fetchReq = NSFetchRequest<Log>(entityName: "Log")
            let sortByTimeStamp = NSSortDescriptor(key: "timeStamp", ascending: true)
            fetchReq.sortDescriptors = [sortByTimeStamp]
            let logs = try! self.coreDataStack.mainContext.fetch(fetchReq)
            print(logs.count)
            XCTAssertEqual(logs.count,2)
            XCTAssertTrue(logs.contains(log2))
            XCTAssertTrue(logs.contains(log3))
            XCTAssertTrue(self.coreDataStack.mainContext.saveWasCalled)
        }
    }
    
    func test_init_noPrevLogs() {
        var logger = InstabugLogger()
        logger.log(.DEBUG, message: "Init test")
        logger = InstabugLogger()
        let logs = logger.fetchAllLogs()
        XCTAssertEqual(logs.count, 0)
        
    }
    
    func test_saveLog_logsCountLessThanLimit() {
        let logger = InstabugLogger()
        for i in 0...1002 {
            logger.log(.INFO, message: "log nu: \(i)")
            
        }
        
        let logs = logger.fetchAllLogs()
        XCTAssertEqual(logs.count,1000)
        
    }
    
    func testValidateMessage_turncatedMessage() {
        var veryLongMessage = String(repeating: "M", count: 10001)
        let turncatedMessage = String(repeating: "M", count: 1000) + "..."
        veryLongMessage = veryLongMessage.validate()

        XCTAssertEqual(veryLongMessage.count, 1003)
        XCTAssertEqual(veryLongMessage, turncatedMessage)
        XCTAssertEqual(String(veryLongMessage.suffix(3)), "...")
    }
    
}
