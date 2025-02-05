//
//  DailyBonusPost.swift
//  StakeApp
//
//  Created by Gio's Mac on 06.02.25.
//

import Foundation

public struct DailyBonusPost: Codable {
    let message: String
    let nextBonusTime: String

    enum CodingKeys: String, CodingKey {
        case message
        case nextBonusTime = "next_bonus_time"
    }
}
