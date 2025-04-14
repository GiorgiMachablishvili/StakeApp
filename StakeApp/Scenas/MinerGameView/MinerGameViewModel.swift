import Foundation

class MinerGameViewModel {

    // MARK: - Properties
    var pointIncrementTimer: Timer?
    var autoPickAxeTimer: Timer?
    var pointInterval: TimeInterval = 1.0
    var botPointsTimeInterval = 0.5
    let randomNumber = Int.random(in: 1...10)

    var currentGoldPoints: Int = 0
    var currentLeftPoints: Int = 0 {
        didSet {
            onPointsUpdated?(currentLeftPoints)
        }
    }

    var isUserBlocked: Bool = false
    var isOpponentScoreBlocked: Bool = false
    var userGameHistory: [UserGameHistory] = []
    var userData: UserDataResponse?

    // MARK: - Callbacks for UI Updates
    var onPointsUpdated: ((Int) -> Void)?
//    var onGameEnded: ((Bool, Int) -> Void)?
    var onUserDataFetched: ((UserDataResponse) -> Void)?
    var onOpponentScoreUpdated: ((Int) -> Void)?
    var onGameEnded: ((Bool, Int, Int) -> Void)?
    var onScoreUpdated: ((Bool) -> Void)?

    // MARK: - Fetch User Data
    
    // MARK: - Fetch User Data
    func fetchUserData(userId: Int) {
        let url = String.userDataResponse(userId: userId)

        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<UserDataResponse>) in
            switch result {
            case .success(let data):
                self.userData = data
                DispatchQueue.main.async {
                    self.onUserDataFetched?(data)
                }
            case .failure(let error):
                print("❌ Error fetching user data: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Increment Points
    func incrementPoints() {
        let randomValue = Int.random(in: 1...10)
        currentLeftPoints += randomValue
    }

    func startPointIncrementTimer() {
        pointIncrementTimer?.invalidate()
        pointIncrementTimer = Timer.scheduledTimer(withTimeInterval: pointInterval, repeats: true) { [weak self] _ in
            self?.incrementPoints()
        }
    }

    func updatePointInterval(to newInterval: TimeInterval) {
        pointInterval = newInterval
        startPointIncrementTimer()
    }

    func stopPointIncrementTimer() {
        pointIncrementTimer?.invalidate()
        pointIncrementTimer = nil
    }

    // MARK: - Handle Auto Pickaxe
    func toggleAutoPickAxe(currentPoints: Int, axeCost: Int) {
        if autoPickAxeTimer != nil {
            autoPickAxeTimer?.invalidate()
            autoPickAxeTimer = nil
            print("Auto-pickaxe disabled!")
            return
        }

        if currentPoints >= axeCost {
            autoPickAxeTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                self?.incrementPoints()
            }
            print("Auto-pickaxe enabled!")
        } else {
            print("Not enough points to enable auto-pickaxe!")
        }
    }

    // MARK: - Handle Bombs
    func pressBombButton(byUser: Bool) {
        if byUser {
            isOpponentScoreBlocked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.isOpponentScoreBlocked = false
            }
        } else {
            isUserBlocked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.isUserBlocked = false
            }
        }
    }

    // MARK: - Handle Double Pickaxe
    func pressDoublePickAxeButton(byUser: Bool, currentPoints: Int, axeCost: Int) {
        if byUser {
            if currentPoints >= axeCost {
                let updatedPoints = currentPoints - axeCost
                currentLeftPoints *= 2
                onPointsUpdated?(updatedPoints)
            } else {
                print("Not enough points for double pickaxe!")
            }
        } else {
            onOpponentScoreUpdated?(currentLeftPoints * 2)
        }
    }

    // MARK: - End Game
    func makeGameGoldButtonUnenabled(opponentScore: Int) {
        autoPickAxeTimer?.invalidate()
        pointIncrementTimer?.invalidate()
        let didWin = currentLeftPoints >= opponentScore
        onGameEnded?(didWin, currentLeftPoints, opponentScore)
    }

    // MARK: - Update Score
    func updateMinerScore(userId: Int, userPoints: Int, opponentPoints: Int, userLevel: Int, opponentLevel: Int, userName: String, opponentName: String, userImage: String?, opponentImage: String?) {

        let result = userPoints >= opponentPoints

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let currentDate = dateFormatter.string(from: Date())

        dateFormatter.dateFormat = "hh:mm a"
        let currentTimeString = dateFormatter.string(from: Date())

        let parameters: [String: Any] = [
            "time": currentTimeString,
            "gameName": "MINERS",
            "result": result,
            "userImage": userImage ?? "",
            "userLevel": userLevel,
            "userName": userName,
            "opponentImage": opponentImage ?? "",
            "opponentLevel": opponentLevel,
            "opponentName": opponentName,
            "userGameScore": userPoints,
            "opponentGameScore": opponentPoints,
            "data": currentDate,
            "userId": userId
        ]

        let url = String.userGameHistoryPost()

        print("📡 Sending POST request to \(url) with parameters: \(parameters)")

        NetworkManager.shared.post(url: url, parameters: parameters, headers: nil) { [weak self] (result: Result<UserGameHistory>) in
            switch result {
            case .success(_):
                print("✅ Score updated successfully")
                self?.onScoreUpdated?(true)
            case .failure(let error):
                print("❌ Error updating score: \(error.localizedDescription)")
                self?.onScoreUpdated?(false)
            }
        }
    }

    //MARK: auto press bomb button and doublePoint Button then the timer drops below 30 and 20
    func handleTimeUpdate(_ remainingSeconds: Int) {
        //MARK: auto press bomb button
        if remainingSeconds == 40 {
            //MARK: Generate a random number of bomb presses (0 to 2)
            let bombPressCount = Int.random(in: 0...2)
            print("Opponent will press bomb button \(bombPressCount) time(s)")

            //MARK: Schedule the bomb presses over the remaining time
            scheduleBombPresses(count: bombPressCount, remainingTime: remainingSeconds, byUser: false)
        }

        //MARK: auto press double point button
        if remainingSeconds == 30 {
            //MARK: Generate a random number of bomb presses (1 to 3)
            let doublePointCount = Int.random(in: 0...2)
            print("Opponent will press double button \(doublePointCount) time(s)")

            //MARK: Schedule the double button presses over the remaining time
            scheduleDoublePresses(count: doublePointCount, remainingTime: remainingSeconds, byUser: false)
        }
    }

    //MARK: schedule bomb presses
    private func scheduleBombPresses(count: Int, remainingTime: Int, byUser: Bool)  {
        guard count > 0, remainingTime > 1 else { return }

        //MARK: Generate times ensuring at least 7 seconds between presses
        var lastScheduledTime = 0
        let times = (1...count).compactMap { _ -> Int? in
            let minTime = lastScheduledTime + 7
            guard minTime <= remainingTime else { return nil }
            let time = Int.random(in: minTime...remainingTime)
            lastScheduledTime = time
            return time
        }

        for time in times {
            let delay = remainingTime - time
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) { [weak self] in
                self?.pressBombButtons(byUser: false)
            }
        }
    }

    func pressBombButtons(byUser: Bool) {
        if byUser {
            // Block opponent's score updates
            isOpponentScoreBlocked = true

            // Notify UI that the opponent is blocked
            onOpponentScoreUpdated?(0)

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.isOpponentScoreBlocked = false
            }
        } else {
            // Block user's score updates
            isUserBlocked = true

            // Notify UI that the user is blocked
            onPointsUpdated?(currentLeftPoints)

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.isUserBlocked = false
            }
        }
    }


    //MARK: schedule double point presses
    private func scheduleDoublePresses(count: Int, remainingTime: Int, byUser: Bool) {
        guard count > 0, remainingTime > 1 else { return }

        //MARK: Generate times ensuring at least 7 seconds between presses
        var lastScheduledTime = 0
        let times = (1...count).compactMap { _ -> Int? in
            let minTime = lastScheduledTime + 7
            guard minTime <= remainingTime else { return nil }
            let time = Int.random(in: minTime...remainingTime)
            lastScheduledTime = time
            return time
        }
        for time in times {
            let delay = remainingTime - time
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) { [weak self] in
                self?.pressDoublePickAxeButtons(byUser: byUser)
            }
        }
    }

    @objc private func userPressedDoublePickAxeButton() {
            pressDoublePickAxeButtons(byUser: true)
        }

    func pressDoublePickAxeButtons(byUser: Bool) {
        if byUser {
            currentLeftPoints *= 2
            onPointsUpdated?(currentLeftPoints)
        } else {
            // Notify opponent's score is doubled
            onOpponentScoreUpdated?(currentLeftPoints * 2)
        }
    }
}

