//
//  URL+Extension.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import Foundation


extension String {
    static func userCreate() -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/users/register"
    }

    static func userDataResponse(userId: Int) -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/users/\(userId)"
    }

    static func userUpdateDate(userId: Int) -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/users/\(userId)"
    }

    static func userGameHistory() -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/history/"
    }

    static func userDelete(userId: String) -> String {
        let baseURL = "https://betus-workouts-98df47aa38c2.herokuapp.com/api/v1/users/"
        return "\(baseURL)\(userId)"
    }

    static func getUserGameStatistic(userId: String) -> String {
        let baseURL = "https://stake-us-66f6608d21e4.herokuapp.com/user_statistics/"
        return "\(baseURL)\(userId)"
    }
}
