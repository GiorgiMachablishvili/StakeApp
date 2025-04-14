//
//  URL+Extension.swift
//  StakeApp
//
//  Created by Gio's Mac on 30.01.25.
//

import Foundation


extension String {
    static func userCreate() -> String {
        return "https://bovagames.fun/users/register"
    }

    static func bonusTimer(userId: Int) -> String {
        return "https://bovagames.fun/bonus/next/\(userId)"
    }

    static func dailyBonusPost(userId: Int) -> String {
        return "https://bovagames.fun/bonus/give/\(userId)"
    }

    static func userDataResponse(userId: Int) -> String {
        return "https://bovagames.fun/users/\(userId)"
    }

    static func leaderBoard() -> String {
        return "https://bovagames.fun/leaderboard"
    }

    static func userUpdateDate(userId: Int) -> String {
        return "https://bovagames.fun/users/\(userId)"
    }

    static func userGameHistoryPost() -> String {
        return "https://bovagames.fun/history/"
    }

    static func userGameHistoryGet(userId: Int) -> String {
        return "https://bovagames.fun/history/\(userId)"
    }

    static func userDelete(userId: Int) -> String {
        return "https://bovagames.fun/users/\(userId)"
    }

    static func getUserGameStatistic(userId: Int) -> String {
        return "https://bovagames.fun/user_statistics/\(userId)"
    }
}
