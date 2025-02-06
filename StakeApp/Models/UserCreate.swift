//
//  UserCreate.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import UIKit

public struct UserCreate: Codable {
    let id: Int
    let username: String
    let image: String?
    let appleToken: String
    let pushToken: String
    let level: Int
    let experience: Int
    let points: Int

    enum CodingKeys: String, CodingKey {
        case username, id, image, level, experience, points
        case appleToken = "auth_token"
        case pushToken = "push_token"
    }
}
