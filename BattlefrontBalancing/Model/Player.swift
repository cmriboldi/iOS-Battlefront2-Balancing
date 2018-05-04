//
//  Player.swift
//  BattlefrontBalancing
//
//  Created by Christian Riboldi on 3/31/18.
//  Copyright © 2018 Christian Riboldi. All rights reserved.
//

import Foundation

class Player {
    var playerName: String
    var playerLevel: Int
    var battleTeam: BattleTeam
    var gameStats: [GameStats]
    var numberOfGames: Int {
        return self.gameStats.count
    }
    var averageKills: Double {
        return self.gameStats.reduce(0.0) { $0 + Double($1.kills) } / Double(numberOfGames)
    }
    var averageKillToDeathRatio: Double {
        return self.gameStats.reduce(0.0) { $0 + Double($1.killsToDeathsRatio) } / Double(numberOfGames)
    }
    var averageBattlePoints: Double {
        return self.gameStats.reduce(0.0) { $0 + Double($1.battlePoints) } / Double(numberOfGames)
    }
    var averageEliminations: Double {
        return self.gameStats.reduce(0.0) { $0 + Double($1.eliminations) } / Double(numberOfGames)
    }
    var averageBattlePointsFromObjectives: Double {
        return self.gameStats.reduce(0.0) { $0 + Double($1.battlePointsFromObjective) } / Double(numberOfGames)
    }
    var averageBattlePointsFromAbilities: Double {
        return self.gameStats.reduce(0.0) { $0 + Double($1.battlePointsFromAbilities) } / Double(numberOfGames)
    }
    var score: Double {
        return PlayerScorer.shared.score(player: self)
    }
    
    
    convenience init(playerName: String, playerLevel: Int, battleTeamNumber: Int? = nil) {
        self.init(playerName: playerName, playerLevel: playerLevel, gameStats: [GameStats](), battleTeamNumber: battleTeamNumber)
    }
    
    init(playerName: String, playerLevel: Int, gameStats: [GameStats], battleTeamNumber: Int? = nil) {
        self.playerName = playerName
        self.playerLevel = playerLevel
        self.gameStats = gameStats
        self.battleTeam = BattleTeam.init(teamNumber: battleTeamNumber)
    }
    
}
