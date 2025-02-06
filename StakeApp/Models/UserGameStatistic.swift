//
//  UserGameStatistic.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import Foundation

struct UserGameStats: Codable {
    let userId: Int
    let exp: Int
    let gamePoints: Int
    let gamePlayedCount: Int
    let gamesWon: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case exp
        case gamePoints = "game_points"
        case gamePlayedCount
        case gamesWon
    }
}
