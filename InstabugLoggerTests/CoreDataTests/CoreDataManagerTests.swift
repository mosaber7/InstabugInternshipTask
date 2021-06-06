//
//  CoreDataManagerTests.swift
//  InstabugLoggerTests
//
//  Created by Saber on 27/05/2021.
//

import XCTest
import CoreData
@testable import InstabugLogger

class CoreDataManagerTests: XCTestCase {
    
    //sut -> subject under test
    var sut: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        
        sut = CoreDataManager()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_setup_completionCalled(){
        let setupexpectation = expectation(description: "set up comletion called")
        sut.setup(storeType: NSInMemoryStoreType)
            setupexpectation.fulfill()
        
        waitForExpectations(timeout: 1.0, handler: nil)
        }
    
    func test_setup_persistentStoreCreated() {
      let setupExpectation = expectation(description: #function)

        setupExpectation.fulfill()
        sut.setup(storeType: NSInMemoryStoreType)
        
        waitForExpectations(timeout: 1.0) { (_) in
        XCTAssertTrue(self.sut.persistentContainer.persistentStoreCoordinator.persistentStores.count > 0)
      }
    }
    
    func test_setup_persistentContainerLoadedOnDisk() {
      let setupExpectation = expectation(description: #function)

      sut.setup()
      XCTAssertEqual(self.sut.persistentContainer.persistentStoreDescriptions.first?.type, NSSQLiteStoreType)
      setupExpectation.fulfill()


      waitForExpectations(timeout: 1.0) { (_) in
        self.sut.persistentContainer.destroyPersistentStore()
      }
    }

    func test_setup_persistentContainerLoadedInMemory() {
      let setupExpectation = expectation(description: #function)

      sut.setup(storeType: NSInMemoryStoreType)
      XCTAssertEqual(self.sut.persistentContainer.persistentStoreDescriptions.first?.type, NSInMemoryStoreType)
      setupExpectation.fulfill()


      waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_backgroundContext_concurrencyType() {
      let setupExpectation = expectation(description: #function)

      sut.setup(storeType: NSInMemoryStoreType)
      XCTAssertEqual(self.sut.backgroundContext.concurrencyType, .privateQueueConcurrencyType)
      setupExpectation.fulfill()


      waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_mainContext_concurrencyType() {
      let setupExpectation = expectation(description: #function)

      sut.setup(storeType: NSInMemoryStoreType)
      XCTAssertEqual(self.sut.mainContext.concurrencyType, .mainQueueConcurrencyType)
      setupExpectation.fulfill()


      waitForExpectations(timeout: 1.0, handler: nil)
    }

}
