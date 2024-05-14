//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Алиса  Грищенкова on 10.05.2024.
//

import XCTest


struct ArithmeticOperations{
    
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

final class MovieQuizTests: XCTestCase {
    
    func testAddition(){
        
        let arithmeticOperation = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        let result = arithmeticOperation.addition(num1: num1, num2: num2)
        
        XCTAssertEqual(result, 3)
        
    }


}













//  override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
