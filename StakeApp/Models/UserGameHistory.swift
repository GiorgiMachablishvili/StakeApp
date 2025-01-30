//
//  UserGameHistory.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import UIKit

public struct UserUserGameHistory: Codable {
    let userId: Int
    let opponentId: Int
    let result: Bool
    let points: Int
    let exp: Int
    let coin: Int
    let data: String
    let gameName: String
    let image: String
    let level: Int
    let id: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case opponentId = "opponent_id"
        case result, points, exp, coin, data, image, level, id
        case gameName = "game_name"
    }
}
