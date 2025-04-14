import Foundation

public struct BonusTimer: Codable {
    let nextBonusTime: String

    enum CodingKeys: String, CodingKey {
        case nextBonusTime = "next_bonus_time"
    }
}
