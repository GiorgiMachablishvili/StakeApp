//
//  BonusTimer .swift
//  StakeApp
//
//  Created by Gio's Mac on 03.02.25.
//

import Foundation

public struct BonusTimer: Codable {
    let nextBonusTime: String

    enum CodingKeys: String, CodingKey {
        case nextBonusTime = "next_bonus_time"
    }
}
