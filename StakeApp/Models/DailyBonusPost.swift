import Foundation

public struct DailyBonusPost: Codable {
    let message: String
    let nextBonusTime: String

    enum CodingKeys: String, CodingKey {
        case message
        case nextBonusTime = "next_bonus_time"
    }
}
