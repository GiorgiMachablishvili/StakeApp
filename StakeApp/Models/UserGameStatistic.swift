//
//  UserGameStatistic.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import Foundation

struct UserGameStats: Codable {
    let gamesPlayed: Int
    let gamesWon: Int

    enum CodingKeys: String, CodingKey {
        case gamesPlayed = "games_played"
        case gamesWon = "games_won"
    }
}
