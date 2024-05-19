//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Алиса  Грищенкова on 14.05.2024.
//
import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    
    var app : XCUIApplication!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton(){
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton(){
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlert(){
        sleep(2)
        
        for _ in 1...10 {
            self.app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game result"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    
    func testAlertDismiss(){
        
    sleep(2)
        
        for _ in 1...10 {
            self.app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game result"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
        
    }
}

