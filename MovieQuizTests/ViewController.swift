//
//  ViewController.swift
//  MovieQuizTests
//
//  Created by Алиса  Грищенкова on 20.05.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func blockButton(isBlocked: Bool) {}
    
    func show(quiz step: QuizStepViewModel) {}
    
    func show(quiz result: QuizResultsViewModel) {}
    
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func showNetworkError(message: String) {}
}
