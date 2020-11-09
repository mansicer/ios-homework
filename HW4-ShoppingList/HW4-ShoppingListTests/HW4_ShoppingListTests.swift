//
//  HW4_ShoppingListTests.swift
//  HW4-ShoppingListTests
//
//  Created by 张福翔 on 2020/11/3.
//

import XCTest
@testable import HW4_ShoppingList

class HW4_ShoppingListTests: XCTestCase {
    // MARK: shopping item tests
    func testShoppingItemInitalizatioinSucceeds() {
        let zeroRatingItem = ShoppingItem(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingItem)
        
        let positiveRatingItem = ShoppingItem(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingItem)
    }
    func testShoppingItemInitalizatioinFailed() {
        let negativeRatingItem = ShoppingItem(name: "Negative", photo: nil, rating: -3)
        XCTAssertNil(negativeRatingItem)
        
        let emptyStringItem = ShoppingItem(name: "", photo: nil, rating: 2)
        XCTAssertNil(emptyStringItem)
        
        let largeRatingItem = ShoppingItem(name: "Large", photo: nil, rating: 43)
        XCTAssertNil(largeRatingItem)
    }
    
    // MARK: pre-defined funcs
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
