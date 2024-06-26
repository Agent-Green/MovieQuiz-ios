//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Алиса  Грищенкова on 21.04.2024.
//

import Foundation
import UIKit


class AlertPresenter : AlertPresenterProtocol {
    
//    weak var delegate : AlertPresenterProtocol?
//    
//    func setup(delegate : AlertPresenterProtocol){
//        self.delegate = delegate}
    
    
    weak var delegate : UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(model result : AlertModel){
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {  _ in
            
            
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
    
}
