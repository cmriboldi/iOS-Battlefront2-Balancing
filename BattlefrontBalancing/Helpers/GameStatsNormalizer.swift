//
//  GameStatsNormalizer.swift
//  BattlefrontBalancing
//
//  Created by Christian Riboldi on 5/4/18.
//  Copyright © 2018 Christian Riboldi. All rights reserved.
//

import Foundation

class GameStatsNormalizer {
    
    var maximumGameStats: GameStats
    var maximumScore: Double
    
    // MARK: - Singleton
    static let shared = GameStatsNormalizer()
    
    fileprivate init() {
        maximumGameStats = GameStats()
        maximumScore = 0.0
    }
    
    func register(_ player: Player) {
        maximumGameStats.maximize(player.gameStats)
        maximumScore = max(maximumScore, player.score)
    }
    
    func normalize(score: Double) -> Double {
        return normalize(value: score, max: maximumScore)
    }
    
    func normalize(kills: Double) -> Double {
        return normalize(value: kills, max: Double(maximumGameStats.kills))
    }
    
    func normalize(killDeathRatio: Double) -> Double {
        return normalize(value: killDeathRatio, max: maximumGameStats.killsToDeathsRatio)
    }
    
    func normalize(eliminations: Double) -> Double {
        return normalize(value: eliminations, max: Double(maximumGameStats.eliminations))
    }
    
    func normalize(pointsFromObjectives: Double) -> Double {
        return normalize(value: pointsFromObjectives, max: Double(maximumGameStats.battlePointsFromObjective))
    }
    
    func normalize(pointsFromAbilities: Double) -> Double {
        return normalize(value: pointsFromAbilities, max: Double(maximumGameStats.battlePointsFromAbilities))
    }
    
    private func normalize(value: Double, max: Double) -> Double {
        return value / max
    }
}
