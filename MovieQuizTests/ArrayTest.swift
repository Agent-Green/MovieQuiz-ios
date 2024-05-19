//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Алиса  Грищенкова on 14.05.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTest : XCTestCase {
    
    func testGetValueInRange () throws{  // test for correct index
        
        // Given
        let array = [1,2,3,4,5,6,7,8,9]
        
        // When
        let value = array[safe: 2]
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws{ // test for incorrect index
        
        // Given
        let array = [1,2,3,4,5,6,7]
        
        // When
        let value = array[safe: 40]
        
        // Then
        XCTAssertNil(value)
    }
}
