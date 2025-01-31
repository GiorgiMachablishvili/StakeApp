//
//  UserDataResponse.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import UIKit

struct UserDataResponse: Codable {
    let id: Int
    let username: String
    let image: String
    let pushToken: String
    let authToken: String
    let level: Int
    let experience: Int
    let points: Int

    enum CodingKeys: String, CodingKey {
        case id, username, image
        case pushToken = "push_token"
        case authToken = "auth_token"
        case level, experience, points
    }
}
