//
//  GameStats.swift
//  BattlefrontBalancing
//
//  Created by Christian Riboldi on 3/31/18.
//  Copyright © 2018 Christian Riboldi. All rights reserved.
//

import Foundation

class GameStats {
    
    struct Constants {
        static let pointsPerKill: Int = 300
        static let pointsPerAssist: Int = 50
    }
    
    var kills: Int
    var assists: Int
    var eliminations: Int {
        return kills + assists
    }
    var deaths: Int
    var killsToDeathsRatio: Double {
        return Double(kills)/Double(deaths)
    }
    var battlePointsFromObjective: Int
    var battlePointsFromAbilities: Int
    var battlePointsFromKills: Int {
        return kills * Constants.pointsPerKill
    }
    var battlePointsFromAssists: Int {
        return assists * Constants.pointsPerAssist
    }
    var battlePointsFromEliminations: Int {
        return battlePointsFromKills + battlePointsFromAssists
    }
    var battlePoints: Int {
        return battlePointsFromObjective + battlePointsFromAbilities + battlePointsFromEliminations
    }
    
    init(kills: Int = 0, assists: Int = 0, deaths: Int = 0, battlePointsFromObjective: Int = 0, battlePointsFromAbilities: Int = 0) {
        self.kills = kills
        self.assists = assists
        self.deaths = deaths
        self.battlePointsFromObjective = battlePointsFromObjective
        self.battlePointsFromAbilities = battlePointsFromAbilities
    }
    
    func minimize(_ gameStats: [GameStats]) {
        self.kills = min(self.kills, gameStats.max(by: { a, b in a.kills > b.kills })!.kills)
        self.assists = min(self.assists, gameStats.max(by: { a, b in a.assists > b.assists })!.assists)
        self.deaths = min(self.deaths, gameStats.max(by: { a, b in a.deaths > b.deaths })!.deaths)
        self.battlePointsFromObjective = min(self.battlePointsFromObjective, gameStats.max(by: { a, b in a.battlePointsFromObjective > b.battlePointsFromObjective })!.battlePointsFromObjective)
        self.battlePointsFromAbilities = min(self.battlePointsFromAbilities, gameStats.max(by: { a, b in a.battlePointsFromAbilities > b.battlePointsFromAbilities })!.battlePointsFromAbilities)
    }
    
    func maximize(_ gameStats: [GameStats]) {
        self.kills = max(self.kills, gameStats.max(by: { a, b in a.kills < b.kills })!.kills)
        self.assists = max(self.assists, gameStats.max(by: { a, b in a.assists < b.assists })!.assists)
        self.deaths = max(self.deaths, gameStats.max(by: { a, b in a.deaths < b.deaths })!.deaths)
        self.battlePointsFromObjective = max(self.battlePointsFromObjective, gameStats.max(by: { a, b in a.battlePointsFromObjective < b.battlePointsFromObjective })!.battlePointsFromObjective)
        self.battlePointsFromAbilities = max(self.battlePointsFromAbilities, gameStats.max(by: { a, b in a.battlePointsFromAbilities < b.battlePointsFromAbilities })!.battlePointsFromAbilities)
    }
    
}
