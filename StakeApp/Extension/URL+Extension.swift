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

    static func bonusTimer() -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/bonus/next"
    }

    static func dailyBonusPost(userId: Int) -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/bonus/give/\(userId)"
    }

    static func userDataResponse(userId: Int) -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/users/\(userId)"
    }

    static func leaderBoard() -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/leaderboard"
    }

    static func userUpdateDate(userId: Int) -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/users/\(userId)"
    }

    static func userGameHistoryPost() -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/history/"
    }

    static func userGameHistoryGet(userId: Int) -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/history/\(userId)"
    }

    static func userDelete(userId: Int) -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/users/\(userId)"
    }

    static func getUserGameStatistic(userId: Int) -> String {
        return "https://stake-us-66f6608d21e4.herokuapp.com/user_statistics/\(userId)"
    }
}
