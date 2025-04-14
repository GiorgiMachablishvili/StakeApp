import UIKit

struct LeaderBoardStatic: Codable {
    let id: Int
    let username: String
    let image: String?
    let pushToken: String
    let authToken: String
    let level: Int
    let experience: Int
    let points: Int

    enum CodingKeys: String, CodingKey {
        case id, username, image, level, experience, points
        case pushToken = "push_token"
        case authToken = "auth_token"
    }
}
