//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Алиса  Грищенкова on 21.04.2024.
//

import Foundation
import UIKit

struct AlertModel{
    var title : String
    var message : String
    var buttonText : String
    
    let completion : () -> Void
}
