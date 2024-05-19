//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Алиса  Грищенкова on 19.05.2024.
//

import Foundation
import UIKit


final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var statisticService : StatisticServiceProtocol!
    var questionFactory: QuestionFactoryProtocol?
    var alertPresenter : AlertPresenter?
    
    
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    var correctAnswers: Int = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController : MovieQuizViewController?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        alertPresenter = AlertPresenter(delegate: viewController)
        
        statisticService = StatisticServiceImplementation()
        
    }
    
    func isLastQuestion() -> Bool {
        return currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
        
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let result = QuizStepViewModel(
            image : UIImage(data: model.image) ?? UIImage(),
            question : model.text,
            questionNumber : "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return result
    }
    
    func yesButtonClicked() {
        
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes:Bool){
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else {return}
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        
        viewController?.imageUI.layer.borderWidth = 0
        
        if self.isLastQuestion(){
            
            let message = self.makeResultsMessage()
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: message,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    guard let self else { return }
                    self.restartGame()
                    questionFactory?.requestNextQuestion()
                })
            alertPresenter?.showAlert(model: alertModel)
            
        } else {
            self.switchToNextQuestion()
            
            self.questionFactory?.requestNextQuestion()
            
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
}
