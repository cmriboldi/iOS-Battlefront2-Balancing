//
//  TeamsViewController.swift
//  BattlefrontBalancing
//
//  Created by Christian Riboldi on 3/31/18.
//  Copyright © 2018 Christian Riboldi. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //
    // MARK: - IBActions
    //
    @IBAction func rebalanceTeams(_ sender: Any) {
        Players.shared.rebalanceTeams()
        tableView.reloadData()
        print("done rebalancing teams")
    }
    
    //
    // MARK: - UITableViewDelegate functions
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return Players.shared.players.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRect(x: 20.0, y: 5.0, width: 200.0, height: 25.0))
        headerLabel.text = (section == 0) ? "Team One" : "Team Two"
        headerLabel.font = UIFont.systemFont(ofSize: 25.0)
        headerLabel.backgroundColor = UIColor(rgb: 0xE6E6E6)
        
        let teamCountLabel = UILabel(frame: CGRect(x: 20.0, y: 35.0, width: 200.0, height: 20.0))
        teamCountLabel.text = "Team Size: \(Players.shared.getPlayers(fromTeam: PlayerTeam(teamNumber: section)).count)"
        teamCountLabel.backgroundColor = UIColor(rgb: 0xE6E6E6)
        let teamScoreLabel = UILabel(frame: CGRect(x: 200.0, y: 35.0, width: 200.0, height: 20.0))
        teamScoreLabel.text = "Team score: \(Players.shared.getTeamScore(forTeam: PlayerTeam(teamNumber: section)))"
        teamScoreLabel.backgroundColor = UIColor(rgb: 0xE6E6E6)
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 60.0))
        headerView.backgroundColor = UIColor(rgb: 0xE6E6E6)
        headerView.addSubview(headerLabel)
        headerView.addSubview(teamCountLabel)
        headerView.addSubview(teamScoreLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Players.shared.getPlayers(fromTeam: PlayerTeam(teamNumber: section)).count
    }
    
    //
    // MARK: - UITableViewDataSource functions
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        
        let player = Players.shared.getPlayers(fromTeam: PlayerTeam(teamNumber: indexPath.section))[indexPath.row]
        cell.textLabel?.text = player.playerName
        cell.detailTextLabel?.text = "Player score: \(player.score)    \((player.battleTeam != .none) ? "Battle Team: \(player.battleTeam)" : "")"
        cell.backgroundColor = player.battleTeam.color()
        
        return cell
    }

}

