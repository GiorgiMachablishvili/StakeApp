//
//  UserGameHistory.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import UIKit

public struct UserGameHistory: Codable {
    let time: String
    let id: Int
    let result: Bool
    let opponentId: Int?
    let userLevel: Int?
    let opponentImage: String?
    let opponentName: String?
    let opponentGameScore: Int
    let gameName: String
    let userId: Int?
    let userImage: String?
    let userName: String?
    let opponentLevel: Int?
    let userGameScore: Int
    let data: String?

    enum CodingKeys: String, CodingKey {
        case time, result, data, id
        case gameName = "game_name"
        case userImage = "user_image"
        case userLevel = "user_level"
        case userName = "user_name"
        case opponentImage = "opponent_image"
        case opponentLevel = "opponent_level"
        case opponentName = "opponent_name"
        case userGameScore = "user_game_score"
        case opponentGameScore = "opponent_game_score"
        case userId = "user_id"
        case opponentId = "opponent_id"
    }
}

