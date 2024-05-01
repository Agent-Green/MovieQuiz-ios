//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Алиса  Грищенкова on 01.05.2024.
//

import Foundation

final class StatisticServiceImplementation : StatisticServiceProtocol{
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var totalAccuracy: Double {
        get{
            let total = userDefaults.double(forKey: Keys.total.rawValue)
            let correct = userDefaults.double(forKey: Keys.correct.rawValue)
            return (correct / total) * 100
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        gamesCount += 1
        
        let correct = userDefaults.integer(forKey: Keys.correct.rawValue) + count
        userDefaults.set(correct, forKey: Keys.correct.rawValue)
        
        let total = userDefaults.integer(forKey: Keys.total.rawValue) + amount
        userDefaults.set(total, forKey: Keys.total.rawValue)
        
        let newGame = GameRecord(correct: count, total: amount, date: Date())
        
        if newGame.isBetterThan(bestGame){
            bestGame = newGame
        }
        
    }
    
    
}
