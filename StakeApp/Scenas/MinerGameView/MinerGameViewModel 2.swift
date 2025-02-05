//
//  MinerGameViewModel.swift
//  StakeApp
//
//  Created by Gio's Mac on 04.02.25.
//


import Foundation

class MinerGameViewModel {
    // MARK: - Properties
    var currentGoldPoints: Int = 0
    var currentLeftPoints: Int = 0
    private var autoPickAxeTimer: Timer?
    private var pointIncrementTimer: Timer?
    private var pointInterval: TimeInterval = 1.0
    private var botPointsTimeInterval = 0.5

    private var isUserBlocked: Bool = false
    private var isOpponentScoreBlocked: Bool = false

    var userData: UserDataResponse?
    var leaderboardUsers: [LeaderBoardStatic] = []

    // MARK: - Game Logic
    func startGame() {
        startPointIncrementTimer()
    }

    func stopGame() {
        stopPointIncrementTimer()
        autoPickAxeTimer?.invalidate()
    }

    func incrementPoints() {
        let randomValue = Int.random(in: 1...10)
        currentLeftPoints += randomValue
    }

    func pressGoldButton() {
        if isUserBlocked || isOpponentScoreBlocked { return }
        let randomIncrement = Int.random(in: 1...10)
        currentLeftPoints += randomIncrement
    }

    func pressDoublePickAxeButton(byUser: Bool = true) {
        if byUser {
            // Deduct points and double the score
            currentLeftPoints *= 2
        } else {
            // Double the opponent's score
            // (Assuming opponent's score is managed elsewhere)
        }
    }

    func pressBombButton(byUser: Bool = true) {
        if byUser {
            isOpponentScoreBlocked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.isOpponentScoreBlocked = false
            }
        } else {
            isUserBlocked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.isUserBlocked = false
            }
        }
    }

    func pressAutoPickAxeButton() {
        if autoPickAxeTimer != nil {
            autoPickAxeTimer?.invalidate()
            autoPickAxeTimer = nil
        } else {
            autoPickAxeTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                self?.pressGoldButton()
            }
        }
    }

    // MARK: - Timer Management
    private func startPointIncrementTimer() {
        pointIncrementTimer?.invalidate()
        pointIncrementTimer = Timer.scheduledTimer(withTimeInterval: pointInterval, repeats: true) { [weak self] _ in
            self?.incrementPoints()
        }
    }

    private func stopPointIncrementTimer() {
        pointIncrementTimer?.invalidate()
        pointIncrementTimer = nil
    }

    // MARK: - Data Fetching
    func fetchUserData(completion: @escaping () -> Void) {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("❌ Error: No userId found in UserDefaults")
            return
        }

        let url = String.userDataResponse(userId: userId)
        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { [weak self] (result: Result<UserDataResponse>) in
            switch result {
            case .success(let data):
                self?.userData = data
                completion()
            case .failure(let error):
                print("❌ Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
}
