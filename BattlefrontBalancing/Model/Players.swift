//
//  Players.swift
//  BattlefrontBalancing
//
//  Created by Christian Riboldi on 3/31/18.
//  Copyright © 2018 Christian Riboldi. All rights reserved.
//

import Foundation

enum PlayerTeam {
    case one, two, none
    
    init(teamNumber: Int) {
        switch teamNumber {
        case 0:
            self = .one
        case 1:
            self = .two
        default:
            self = .none
        }
    }
    
    func oppositeTeam() -> PlayerTeam {
        switch self {
        case .one:
            return .two
        case .two:
            return .one
        default:
            return .none
        }
    }
}

class Players {
    
    struct Constants {
        static let maxTeamSize = 20
        static let insignificantFactorLimit: Double = 0.5
    }
    
    var players: [PlayerTeam: [Player]]
    var teamScores: [PlayerTeam: Double]
    
    // MARK: - Singleton
    static let shared = Players()
    
    fileprivate init() {
        players = [PlayerTeam:[Player]]()
        players[.one] = [Player]()
        players[.two] = [Player]()
        
        teamScores = [PlayerTeam: Double]()
        resetTeamScores()
        
        print("\n\n\nplayers were: \(players)")
        for (i, player) in StartingData.players.enumerated() {
            add(player, toTeam: StartingData.teams[i])
            GameStatsNormalizer.shared.register(player)
        }
        print("\n\n\nplayers are: \(players)")
    }
    
    func getPlayers(fromTeam team: PlayerTeam) -> [Player] {
        return players[team] ?? [Player]()
    }
    
    func getTeamScore(forTeam team: PlayerTeam) -> Double {
        return getPlayers(fromTeam: team).reduce(0) { $0 + PlayerScorer.shared.score(player: $1) }
    }
    
    func rebalanceTeams() {
        var priorityQueue = PriorityQueue(sort: higherScore)
        resetTeamScores()
        
        for team in [PlayerTeam.one, PlayerTeam.two] {
            if let teamPlayers = players[team] {
                for player in teamPlayers {
                    priorityQueue.enqueue(player)
                }
            }
            players[team] = [Player]()
        }
        
        while !priorityQueue.isEmpty {
            if let player = priorityQueue.dequeue() {
                add(player, toTeam: getTeamToJoin(forPlayer: player, withRemainingPlayers: priorityQueue), shouldPrint: false) // Change to true if I need to print out the add functionality.
            }
        }
    }
    
    private func resetTeamScores() {
        teamScores[.one] = 0.0
        teamScores[.two] = 0.0
    }
    
    // TODO: This is where I need to add all of the remaining functionality in order to check if a friend is in a battle team and you were going to be assigned to a different team.
    private func getTeamToJoin(forPlayer player: Player, withRemainingPlayers remainingPlayers: PriorityQueue<Player>) -> PlayerTeam {
        // Put the player on the team with the lowest team score.
        var teamToJoin: PlayerTeam = .one
        if teamScores[.one]! > teamScores[.two]! {
            teamToJoin = .two
        }
        
        let isLastPlayerInBattleTeam = remainingPlayers.index(withBattleTeam: player.battleTeam) == nil
        let hasTeammatesInTeamToJoin = players[teamToJoin]!.contains(where: { $0.battleTeam == player.battleTeam })

        if isLastPlayerInBattleTeam && !hasTeammatesInTeamToJoin {

            let halfOfRemaingPlayers = remainingPlayers.getNTopNodesAsArray(n: remainingPlayers.count/2)
            let remainingPlayersScore = halfOfRemaingPlayers.reduce(0) { $0 + $1.score }

            let halfRemainingPlayersCanCompensateForCurrentPlayer = (teamScores[teamToJoin]! + player.score) < ((teamScores[teamToJoin.oppositeTeam()]! + remainingPlayersScore)) ||
                                                                    (GameStatsNormalizer.shared.normalize(score: player.score) < Constants.insignificantFactorLimit)

            if halfRemainingPlayersCanCompensateForCurrentPlayer {
                teamToJoin = teamToJoin.oppositeTeam()
            }
        }
        
        if players[teamToJoin]!.count >= Constants.maxTeamSize && players[teamToJoin.oppositeTeam()]!.count < Constants.maxTeamSize {
            teamToJoin = teamToJoin.oppositeTeam()
        }
        
        return teamToJoin
    }
    
    private func higherScore (p1: Player, p2: Player) -> Bool {
        return p1.score > p2.score
    }
    
    private func add(_ player: Player, toTeam team: PlayerTeam, shouldPrint: Bool = false) {
        if shouldPrint {
            print("\n\n\nAdding \(player.playerName) with score of: \(player.score) to team: \(team)")
            print("score was: \(teamScores[team]!)")
        }
        
        players[team]?.append(player)
        teamScores[team]? += player.score
        
        if shouldPrint {
            print("score is: \(teamScores[team]!)")
        }
    }
    
    //
    // MARK: - Starting Data
    //
    fileprivate struct StartingData {
        static let players: [Player] = [Player(playerName: "I_MF_DOOM_II", playerLevel: 42, gameStats: [StartingData.gameStats[0]], battleTeamNumber: 1),
                                        Player(playerName: "xlaNolx", playerLevel: 46, gameStats: [StartingData.gameStats[1]], battleTeamNumber: 1),
                                        Player(playerName: "Mathamuchew", playerLevel: 43, gameStats: [StartingData.gameStats[2]], battleTeamNumber: 1),
                                        Player(playerName: "BS_BloodSpiller", playerLevel: 20, gameStats: [StartingData.gameStats[3]], battleTeamNumber: 1),
                                        Player(playerName: "monkeyAttak", playerLevel: 30, gameStats: [StartingData.gameStats[4]]),
                                        Player(playerName: "Auffemberg", playerLevel: 20, gameStats: [StartingData.gameStats[5]], battleTeamNumber: 1),
                                        Player(playerName: "ren008", playerLevel: 19, gameStats: [StartingData.gameStats[6]]),
                                        Player(playerName: "WOLFMOTHER", playerLevel: 30, gameStats: [StartingData.gameStats[7]]),
                                        Player(playerName: "PrimarchPrime", playerLevel: 23, gameStats: [StartingData.gameStats[8]]),
                                        Player(playerName: "MrFluffy909", playerLevel: 14, gameStats: [StartingData.gameStats[9]]),
                                        Player(playerName: "EpicDumDum", playerLevel: 16, gameStats: [StartingData.gameStats[10]]),
                                        Player(playerName: "KobeQB19", playerLevel: 13, gameStats: [StartingData.gameStats[11]]),
                                        Player(playerName: "senlock", playerLevel: 14, gameStats: [StartingData.gameStats[12]]),
                                        Player(playerName: "third_sequence", playerLevel: 16, gameStats: [StartingData.gameStats[13]]),
                                        Player(playerName: "Madcopy3", playerLevel: 18, gameStats: [StartingData.gameStats[14]]),
                                        Player(playerName: "Cade746", playerLevel: 17, gameStats: [StartingData.gameStats[15]]),
                                        Player(playerName: "AntdogAL", playerLevel: 13, gameStats: [StartingData.gameStats[16]]),
                                        Player(playerName: "julito_tiger", playerLevel: 15, gameStats: [StartingData.gameStats[17]]),
                                        Player(playerName: "aldomarth", playerLevel: 12, gameStats: [StartingData.gameStats[18]]),
                                        Player(playerName: "jacobsteelers519", playerLevel: 11, gameStats: [StartingData.gameStats[19]]),
                                        Player(playerName: "Ascari_X", playerLevel: 14, gameStats: [StartingData.gameStats[20]], battleTeamNumber: 2),
                                        Player(playerName: "Cookies_n_Clips", playerLevel: 13, gameStats: [StartingData.gameStats[21]]),
                                        Player(playerName: "AlexR043", playerLevel: 17, gameStats: [StartingData.gameStats[22]]),
                                        Player(playerName: "ZX_KillerCroc_XA", playerLevel: 16, gameStats: [StartingData.gameStats[23]], battleTeamNumber: 2),
                                        Player(playerName: "GOAT4213", playerLevel: 13, gameStats: [StartingData.gameStats[24]], battleTeamNumber: 2),
                                        Player(playerName: "DANBIGS", playerLevel: 14, gameStats: [StartingData.gameStats[25]], battleTeamNumber: 2),
                                        Player(playerName: "pepemsc", playerLevel: 17, gameStats: [StartingData.gameStats[26]]),
                                        Player(playerName: "holken305", playerLevel: 9, gameStats: [StartingData.gameStats[27]]),
                                        Player(playerName: "Svenlemon", playerLevel: 8, gameStats: [StartingData.gameStats[28]]),
                                        Player(playerName: "Sandhauler14", playerLevel: 7, gameStats: [StartingData.gameStats[29]]),
                                        Player(playerName: "CheeckyChickens", playerLevel: 7, gameStats: [StartingData.gameStats[30]], battleTeamNumber: 3),
                                        Player(playerName: "Dinofights", playerLevel: 8, gameStats: [StartingData.gameStats[31]], battleTeamNumber: 3),
                                        Player(playerName: "Tegetthoff_Will", playerLevel: 6, gameStats: [StartingData.gameStats[32]], battleTeamNumber: 3),
                                        Player(playerName: "Chalkus", playerLevel: 4, gameStats: [StartingData.gameStats[33]]),
                                        Player(playerName: "QuasiMOB", playerLevel: 7, gameStats: [StartingData.gameStats[34]]),
                                        Player(playerName: "davidf29", playerLevel: 3, gameStats: [StartingData.gameStats[35]]),
                                        Player(playerName: "OneKnighmare", playerLevel: 5, gameStats: [StartingData.gameStats[36]], battleTeamNumber: 4),
                                        Player(playerName: "Fision_Chips", playerLevel: 2, gameStats: [StartingData.gameStats[37]]),
                                        Player(playerName: "DanyTheFox", playerLevel: 4, gameStats: [StartingData.gameStats[38]], battleTeamNumber: 4),
                                        Player(playerName: "roketfiq", playerLevel: 2, gameStats: [StartingData.gameStats[39]])]
        
        static let gameStats: [GameStats] =  [GameStats(kills: 50, assists: 33, deaths: 6, battlePointsFromObjective: 10500, battlePointsFromAbilities: 7849),
                                                GameStats(kills: 80, assists: 31, deaths: 7, battlePointsFromObjective: 9191, battlePointsFromAbilities: 0),
                                                GameStats(kills: 32, assists: 16, deaths: 6, battlePointsFromObjective: 3230, battlePointsFromAbilities: 0),
                                                GameStats(kills: 34, assists: 8, deaths: 5, battlePointsFromObjective: 2244, battlePointsFromAbilities: 0),
                                                GameStats(kills: 13, assists: 6, deaths: 10, battlePointsFromObjective: 3475, battlePointsFromAbilities: 3909),
                                                GameStats(kills: 12, assists: 9, deaths: 6, battlePointsFromObjective: 2688, battlePointsFromAbilities: 2223),
                                                GameStats(kills: 8, assists: 2, deaths: 8, battlePointsFromObjective: 2088, battlePointsFromAbilities: 2371),
                                                GameStats(kills: 12, assists: 2, deaths: 14, battlePointsFromObjective: 1990, battlePointsFromAbilities: 942),
                                                GameStats(kills: 14, assists: 7, deaths: 7, battlePointsFromObjective: 1622, battlePointsFromAbilities: 0),
                                                GameStats(kills: 5, assists: 4, deaths: 10, battlePointsFromObjective: 1788, battlePointsFromAbilities: 2472),
                                                GameStats(kills: 4, assists: 6, deaths: 11, battlePointsFromObjective: 1788, battlePointsFromAbilities: 2671),
                                                GameStats(kills: 8, assists: 6, deaths: 8, battlePointsFromObjective: 1747, battlePointsFromAbilities: 1377),
                                                GameStats(kills: 10, assists: 12, deaths: 10, battlePointsFromObjective: 17724, battlePointsFromAbilities: 422),
                                                GameStats(kills: 3, assists: 5, deaths: 9, battlePointsFromObjective: 1541, battlePointsFromAbilities: 2444),
                                                GameStats(kills: 8, assists: 6, deaths: 12, battlePointsFromObjective: 1478, battlePointsFromAbilities: 749),
                                                GameStats(kills: 11, assists: 5, deaths: 13, battlePointsFromObjective: 1063, battlePointsFromAbilities: 0),
                                                GameStats(kills: 3, assists: 4, deaths: 14, battlePointsFromObjective: 1286, battlePointsFromAbilities: 1900),
                                                GameStats(kills: 3, assists: 3, deaths: 8, battlePointsFromObjective: 1217, battlePointsFromAbilities: 1790),
                                                GameStats(kills: 3, assists: 3, deaths: 9, battlePointsFromObjective: 1190, battlePointsFromAbilities: 1727),
                                                GameStats(kills: 3, assists: 2, deaths: 13, battlePointsFromObjective: 1189, battlePointsFromAbilities: 1774),
                                                GameStats(kills: 3, assists: 6, deaths: 14, battlePointsFromObjective: 1185, battlePointsFromAbilities: 1566),
                                                GameStats(kills: 6, assists: 7, deaths: 13, battlePointsFromObjective: 1179, battlePointsFromAbilities: 601),
                                                GameStats(kills: 1, assists: 3, deaths: 17, battlePointsFromObjective: 1154, battlePointsFromAbilities: 2243),
                                                GameStats(kills: 3, assists: 4, deaths: 16, battlePointsFromObjective: 1113, battlePointsFromAbilities: 1498),
                                                GameStats(kills: 0, assists: 2, deaths: 20, battlePointsFromObjective: 1112, battlePointsFromAbilities: 2495),
                                                GameStats(kills: 0, assists: 2, deaths: 23, battlePointsFromObjective: 1108, battlePointsFromAbilities: 2486),
                                                GameStats(kills: 0, assists: 2, deaths: 24, battlePointsFromObjective: 1063, battlePointsFromAbilities: 2379),
                                                GameStats(kills: 7, assists: 7, deaths: 11, battlePointsFromObjective: 958, battlePointsFromAbilities: 0),
                                                GameStats(kills: 1, assists: 5, deaths: 26, battlePointsFromObjective: 1013, battlePointsFromAbilities: 1812),
                                                GameStats(kills: 6, assists: 7, deaths: 12, battlePointsFromObjective: 1002, battlePointsFromAbilities: 187),
                                                GameStats(kills: 5, assists: 7, deaths: 18, battlePointsFromObjective: 976, battlePointsFromAbilities: 426),
                                                GameStats(kills: 3, assists: 6, deaths: 19, battlePointsFromObjective: 964, battlePointsFromAbilities: 1050),
                                                GameStats(kills: 0, assists: 1, deaths: 20, battlePointsFromObjective: 826, battlePointsFromAbilities: 1876),
                                                GameStats(kills: 3, assists: 7, deaths: 21, battlePointsFromObjective: 749, battlePointsFromAbilities: 496),
                                                GameStats(kills: 0, assists: 1, deaths: 29, battlePointsFromObjective: 622, battlePointsFromAbilities: 1400),
                                                GameStats(kills: 0, assists: 1, deaths: 30, battlePointsFromObjective: 536, battlePointsFromAbilities: 1201),
                                                GameStats(kills: 2, assists: 3, deaths: 24, battlePointsFromObjective: 509, battlePointsFromAbilities: 436),
                                                GameStats(kills: 0, assists: 5, deaths: 33, battlePointsFromObjective: 358, battlePointsFromAbilities: 585),
                                                GameStats(kills: 1, assists: 3, deaths: 23, battlePointsFromObjective: 349, battlePointsFromAbilities: 363),
                                                GameStats(kills: 0, assists: 0, deaths: 35, battlePointsFromObjective: 133, battlePointsFromAbilities: 309)]
        
        static let teams: [PlayerTeam] = [.one,.one,.one,.one,.two,.one,.two,.two,.one,.two,.two,.one,.one,.two,.one,.one,.one,.two,.two,.two,.two,.one,.two,.two,.two,.two,.two,
                                                  .one,.two,.one,.one,.one,.one,.one,.two,.two,.one,.two,.one,.two]
    }
}
