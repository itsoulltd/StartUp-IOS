//
//  RokomariReaderTests.swift
//  RokomariReaderTests
//
//  Created by Towhid Islam on 10/25/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import XCTest
import CoreDataStack
@testable import RokomariReader

class RokomariReaderTests: XCTestCase {
    
    var items: [NGObjectProtocol]!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        items = [NGObjectProtocol]()
        items.append(NGObject(info: ["name":"towhid","age":32,"dob":DateManager .sharedInstance().day(after: 54)]))
        items.append(NGObject(info: ["name":"Sohana","age":23,"dob":DateManager .sharedInstance().day(after: 23)]))
        items.append(NGObject(info: ["name":"Tanvir","age":28,"dob":DateManager .sharedInstance().day(after: 12)]))
        items.append(NGObject(info: ["name":"Sumaiya","age":19,"dob":DateManager .sharedInstance().day(after: 19)]))
        items.append(NGObject(info: ["name":"Maruf","age":32,"dob":DateManager .sharedInstance().day(after: 20)]))
        items.append(NGObject(info: ["name":"Tushin","age":14,"dob":DateManager .sharedInstance().day(after: 20)]))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        items.removeAll()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSorting(){
        
        for item in items {
            print(item.serializeIntoInfo())
        }
        print("After Sort:")
        let alphaSort = AlphabeticalSort()
        let sortedItems = alphaSort.sort(items, forKeyPath: "name", order: ComparisonResult.orderedAscending)
        for item in sortedItems {
            print(item.serializeIntoInfo())
        }
        
    }
    
}
