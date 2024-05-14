//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Алиса  Грищенкова on 21.04.2024.
//

import Foundation

protocol AlertPresenterProtocol : AnyObject {
    
    func showAlert(model result : AlertModel)
}
