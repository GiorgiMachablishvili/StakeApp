//
//  TopViewInfo.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import UIKit

public struct TopViewInfo: Codable {
    let userImage: String
    let userLevel: Int
    let userName: String
    let exp: Int
    let point: Int

    enum CodingKeys: String, CodingKey {
        case userImage = "user_image"
        case userLevel = "user_level"
        case userName = "user_name"
        case exp,point
    }
}
