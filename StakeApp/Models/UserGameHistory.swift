//
//  UserGameHistory.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import UIKit

public struct UserGameHistory: Codable {
    let time: String
    let gameName: String
    let result: Bool
    let userImage: String
    let userLevel: Int
    let userName: String
    let opponentImage: String
    let opponentLevel: Int
    let opponentName: String
    let userGameScore: Int
    let opponentGameScore: Int
    let data: String
    let userId: Int
    let opponentId: Int

    enum CodingKeys: String, CodingKey {
        case time, result, data
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

