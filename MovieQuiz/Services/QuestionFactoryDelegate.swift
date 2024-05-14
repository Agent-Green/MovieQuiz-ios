//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Алиса  Грищенкова on 21.04.2024.
//

import Foundation

protocol QuestionFactoryDelegate : AnyObject {
    func didReceiveNextQuestion (question : QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
