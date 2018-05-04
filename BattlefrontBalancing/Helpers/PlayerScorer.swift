//
//  PlayerScorer.swift
//  BattlefrontBalancing
//
//  Created by Christian Riboldi on 5/3/18.
//  Copyright © 2018 Christian Riboldi. All rights reserved.
//

import Foundation

class PlayerScorer {
    
    // MARK: - Constants
    private struct Constants {
        static let killsWeight: Double = 3.0
        static let killDeathRatioWeight: Double = 1.5
        static let eliminationsWeight: Double = 1.5
        static let objectivesWeight: Double = 0.4
        static let abilitiesWeight: Double = 0.3
    }
    
    // MARK: - Singleton
    static let shared = PlayerScorer()
    
    fileprivate init() {}
    
    func score(player: Player) -> Double {
        return ((GameStatsNormalizer.shared.normalize(kills: player.averageKills) * Constants.killsWeight) +
               (GameStatsNormalizer.shared.normalize(killDeathRatio: player.averageKillToDeathRatio) * Constants.killDeathRatioWeight) +
               (GameStatsNormalizer.shared.normalize(eliminations: player.averageEliminations) * Constants.eliminationsWeight) +
               (GameStatsNormalizer.shared.normalize(pointsFromObjectives: player.averageBattlePointsFromObjectives) * Constants.objectivesWeight) +
               (GameStatsNormalizer.shared.normalize(pointsFromAbilities: player.averageBattlePointsFromAbilities) * Constants.abilitiesWeight)).rounded(toPlaces: 6)

    }
    
}
