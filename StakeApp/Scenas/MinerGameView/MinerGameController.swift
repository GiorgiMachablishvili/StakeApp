//
//  MinerGameController.swift
//  StakeApp
//
//  Created by Gio's Mac on 18.01.25.
//

import UIKit
import SnapKit

class MinerGameController: UIViewController {

    let randomNumber = Int.random(in: 1...10)
    private var currentGoldPoints: Int = 0
    private var autoPickAxeTimer: Timer?

    private var pointIncrementTimer: Timer?
    private var pointInterval: TimeInterval = 1.0

    private var botPointsTimeInterval = 0.5

    private var isUserBlocked: Bool = false
    private var isOpponentScoreBlocked: Bool = false

    var userGameHistory: [UserGameHistory] = []

    private var currentLeftPoints: Int = 0 {
        didSet {
            gameTimerView.leftPointView.pointLabel.text = "\(currentLeftPoints)"
        }
    }

    private lazy var gameStartTimerView: GameStartTimerView = {
        let view = GameStartTimerView(frame: .zero)
        view.timerDidFinish = { [weak self] in
            self?.hideGameTimerView()
        }
        return view
    }()

    private lazy var gameTopView: GameTopView = {
        let view = GameTopView(frame: .zero)
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(16)
        view.pressPauseButton = { [weak self] in
            self?.quitOrContinueGame()
        }
        return view
    }()

    private lazy var gameBackgroundImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "minerGameBackgroound")
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var gameGoldImage: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "goldenBall"), for: .normal)
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressGameGoldButton), for: .touchUpInside)
        return view
    }()

    private lazy var gameTimerView: GameTimerScoreView = {
        let view = GameTimerScoreView(frame: .zero)
        view.backgroundColor = .clear
        view.timerDidFinish = { [weak self] in
            self?.makeGameGoldButtonUnenabled()
            self?.stopPointIncrementTimer()
        }
        view.onTimeUpdate = { [weak self] remainingSeconds in
            self?.handleTimeUpdate(remainingSeconds)
        }
        return view
    }()

    private lazy var doublePickAxeButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "doublePickAxe"), for: .normal)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 28
        view.backgroundColor = .buttonBackgroundColor
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(userPressedDoublePickAxeButton), for: .touchUpInside)
        return view
    }()

    private lazy var doublePickAxeCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "5"
        return view
    }()

    private lazy var bombButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "bomb"), for: .normal)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 28
        view.backgroundColor = .buttonBackgroundColor
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(userPressedBombButton), for: .touchUpInside)
        return view
    }()

    private lazy var bombCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "5"
        return view
    }()

    private lazy var autoPickAxeButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "autoPickAxe"), for: .normal)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 28
        view.backgroundColor = .buttonBackgroundColor
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressAutoPickAxeButtons), for: .touchUpInside)
        return view
    }()

    private lazy var autoPickAxeCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "20"
        return view
    }()

    private lazy var randomGoldsLabel: RightGamePointView = {
        let view = RightGamePointView()
        view.gameImage.image = UIImage(named: "gold")
        view.pointLabel.text = "+ \(randomNumber)"
        view.backgroundGamePointView.backgroundColor = .clear
        return view
    }()

    private lazy var winOrLoseView: WinOrLoseView = {
        let view = WinOrLoseView(frame: .zero)
        view.backgroundColor = UIColor(hexString: "#16171A")
        view.makeRoundCorners(20)
        view.isHidden = true
        view.didPressStartGameButton = { [weak self] in
            self?.pressStartGameButton()
        }
        view.didPressContinueButton = { [weak self] in
            self?.pressContinueButton()
        }
        return view
    }()

    private lazy var quitOrContinueView: QuitOrContinueView = {
        let view = QuitOrContinueView(frame: .zero)
        view.backgroundColor = UIColor(hexString: "#16171A")
        view.makeRoundCorners(20)
        view.isHidden = true
        view.pressContinueButton = { [weak self] in
            self?.pressContinueGameButton()
        }
        view.pressQuitButton = { [weak self] in
            self?.pressQuitGameButton()
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isUserInteractionEnabled = true
        setup()
        setupConstraints()

        currentLeftPoints = 0

        gameTimerView.pauseTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    private func setup() {
        view.addSubview(gameTopView)
        view.addSubview(gameBackgroundImage)
        gameBackgroundImage.addSubview(gameTimerView)
        gameBackgroundImage.addSubview(doublePickAxeButtons)
        gameBackgroundImage.addSubview(bombButtons)
        gameBackgroundImage.addSubview(autoPickAxeButtons)
        gameBackgroundImage.addSubview(gameGoldImage)
        view.addSubview(doublePickAxeCost)
        view.addSubview(bombCost)
        view.addSubview(autoPickAxeCost)
        view.addSubview(winOrLoseView)
        view.addSubview(quitOrContinueView)
        view.addSubview(gameStartTimerView)
    }

    private func setupConstraints() {
        gameTopView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(104 * Constraint.yCoeff)
        }

        gameStartTimerView.snp.remakeConstraints { make in
            make.top.equalTo(gameTopView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        gameBackgroundImage.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(gameTopView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom).offset(-56 * Constraint.yCoeff)
        }

        gameGoldImage.snp.remakeConstraints { make in
            make.center.equalTo(gameBackgroundImage.snp.center)
            make.height.width.equalTo(280 * Constraint.yCoeff)
        }

        gameTimerView.snp.remakeConstraints { make in
            make.top.equalTo(gameTopView.snp.bottom).offset(49 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(60 * Constraint.yCoeff)
        }

        doublePickAxeButtons.snp.remakeConstraints { make in
            make.trailing.equalTo(bombButtons.snp.leading).offset(-16 * Constraint.yCoeff)
            make.centerY.equalTo(bombButtons.snp.centerY)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        doublePickAxeCost.snp.remakeConstraints { make in
            make.centerX.equalTo(doublePickAxeButtons.snp.centerX)
            make.bottom.equalTo(doublePickAxeButtons.snp.bottom).offset(5 * Constraint.yCoeff)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.greaterThanOrEqualTo(34 * Constraint.xCoeff)
        }

        bombButtons.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-81 * Constraint.yCoeff)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        bombCost.snp.remakeConstraints { make in
            make.centerX.equalTo(bombButtons.snp.centerX)
            make.bottom.equalTo(bombButtons.snp.bottom).offset(5 * Constraint.yCoeff)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.greaterThanOrEqualTo(34 * Constraint.xCoeff)
        }

        autoPickAxeButtons.snp.remakeConstraints { make in
            make.leading.equalTo(bombButtons.snp.trailing).offset(16 * Constraint.yCoeff)
            make.centerY.equalTo(bombButtons.snp.centerY)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        autoPickAxeCost.snp.remakeConstraints { make in
            make.centerX.equalTo(autoPickAxeButtons.snp.centerX)
            make.bottom.equalTo(autoPickAxeButtons.snp.bottom).offset(5 * Constraint.yCoeff)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.greaterThanOrEqualTo(34 * Constraint.xCoeff)
        }

        winOrLoseView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(652 * Constraint.yCoeff)
        }

        quitOrContinueView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(290 * Constraint.yCoeff)
        }
    }

    //MARK: auto collection points for bot
    private func startPointIncrementTimer() {
        pointIncrementTimer?.invalidate()
        pointIncrementTimer = Timer.scheduledTimer(withTimeInterval: pointInterval, repeats: true) { [weak self] _ in
            self?.incrementPoints()
        }
    }

    private func incrementPoints() {
        let randomValue = Int.random(in: 1...10)
        DispatchQueue.main.async {
            self.gameTimerView.rightPointView.incrementPoint(by: randomValue)
        }
    }

    func updatePointInterval(to newInterval: TimeInterval) {
        pointInterval = newInterval
        startPointIncrementTimer()
    }

    private func stopPointIncrementTimer() {
        pointIncrementTimer?.invalidate()
        pointIncrementTimer = nil
    }

    //MARK: auto press bomb button and doublePoint Button then the timer drops below 30 and 20
    private func handleTimeUpdate(_ remainingSeconds: Int) {
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

    private func getTopViewCell() -> TopViewCell? {
        guard let mainView = navigationController?.viewControllers.first(where: { $0 is MainView }) as? MainView else {
            return nil
        }
        let collectionView = mainView.exposedCollectionView
        let indexPath = IndexPath(item: 0, section: 0)
        return collectionView.cellForItem(at: indexPath) as? TopViewCell
    }

    private func quitOrContinueGame() {
        print("didi press stop button")
        quitOrContinueView.isHidden = false
    }

    private func hideGameTimerView() {
        gameStartTimerView.isHidden = true
        gameTimerView.startTimer()
        startPointIncrementTimer()

        //MARK: bot points increasing timeInterval
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.updatePointInterval(to: self!.botPointsTimeInterval)
        }
    }

    //MARK: here should make get method
    private func makeGameGoldButtonUnenabled() {
        autoPickAxeTimer?.invalidate()
        gameBackgroundImage.isUserInteractionEnabled = false

        //TODO: what happens in case draw?
        guard let userPointsText = gameTimerView.leftPointView.pointLabel.text,
              let opponentCostText = gameTimerView.rightPointView.pointLabel.text,
              let userPoints = Int(userPointsText),
              let opponentCost = Int(opponentCostText) else {
            return
        }

        winOrLoseView.leftPointView.pointLabel.text = "\(userPoints)"

        if userPoints >= opponentCost {
            winOrLoseView.winOrLoseLabel.text = "WIN!"
            winOrLoseView.bonusButton.isHidden = false
            winOrLoseView.bonusPoints.isHidden = false
            winOrLoseView.expButton.isHidden = false
            winOrLoseView.expPoints.isHidden = false
            winOrLoseView.isHidden = false

            if let topViewCell = getTopViewCell() {
                topViewCell.updateExperiencePoints(add: 10)
            }

        } else {
            winOrLoseView.winOrLoseLabel.text = "LOSE"
            winOrLoseView.winOrLoseLabel.textColor = .red
            winOrLoseView.redExpButton.isHidden = false
            winOrLoseView.redExpPoints.isHidden = false
            winOrLoseView.isHidden = false

            if let topViewCell = getTopViewCell() {
                topViewCell.updateExperiencePoints(add: -1)
            }
        }

        func updateWorkoutScore() {
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                return
            }
            
            //TODO: does not comes here
            var result = Bool()

            if userPoints >= opponentCost {
                result = true
            } else {
                result = false
            }
            // Add day/month/year
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            let currentDate = dateFormatter.string(from: Date())

            // Add time in AM/PM format
            dateFormatter.dateFormat = "hh:mm a"
            let currentTimeString = Int(dateFormatter.string(from: Date())) ?? 0

            let userImage = ""

            let userLevel = Int(gameTimerView.useLevelLabel.text ?? "1") ?? 1

            let userName = gameTimerView.userName.text ?? "User_123"

            let opponentImage = ""

            let opponentLevel = Int(gameTimerView.opponentLevelLabel.text ?? "1") ?? 1

            let opponentName = gameTimerView.opponentName.text ?? "User_234"

            // Create a new WorkoutScore instance
            let newScore = UserGameHistory(
                time: currentTimeString,
                gameName: "MINERS",
                result: result,
                userImage: userImage,
                userLevel: userLevel,
                userName: userName,
                opponentImage: opponentImage,
                opponentLevel: opponentLevel,
                opponentName: opponentName,
                userGameScore: userPoints,
                opponentGameScore: opponentCost,
                data: currentDate,
                userId: userId, 
                opponentId: 0
            )

            userGameHistory.append(newScore)
            postUserScore(newScore)
        }

        func postUserScore(_ score: UserGameHistory) {
            let parameters: [String: Any] = [
                "time": score.time,
                "gameName": score.gameName,
                "result": score.result,
                "userImage": score.userImage,
                "userLevel": score.userLevel,
                "userName": score.userName,
                "opponentImage": score.opponentImage,
                "opponentLevel": score.opponentLevel,
                "opponentName": score.opponentName,
                "userGameScore": score.userGameScore,
                "opponentGameScore": score.opponentGameScore,
                "data": score.data,
                "userId": score.userId,
                "opponentId": score.opponentId
            ]

            let url = String.userGameHistoryPost()
            NetworkManager.shared.showProgressHud(true, animated: true)
            NetworkManager.shared.post(url: url, parameters: parameters, headers: nil) { (result: Result<UserGameHistory>) in
                NetworkManager.shared.showProgressHud(false, animated: false)
                switch result {
                case .success(let response):
                    print("Workout saved successfully: \(response)")
                case .failure(let error):
                    print("Error saving workout: \(error.localizedDescription)")
                    print("Request Parameters: \(parameters)")
                }
            }
        }
    }


    //MARK: press gold button
    @objc func pressGameGoldButton() {
        if isUserBlocked {
            print("User is blocked from pressing the gold button!")
            return
        }
        if isOpponentScoreBlocked {
            print("Opponent is blocked from pressing the gold button!")
            return
        }

        let randomIncrement = Int.random(in: 1...10)
        currentLeftPoints += randomIncrement // Update the property instead of the UI directly
        randomGoldsLabel.pointLabel.text = "+ \(randomIncrement)"

        if randomGoldsLabel.superview == nil {
            view.addSubview(randomGoldsLabel)
        }

        randomGoldsLabel.snp.removeConstraints()
        let randomXOffset = CGFloat.random(in: -150...150)
        let randomYOffset = CGFloat.random(in: -150...150)
        randomGoldsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX).offset(randomXOffset)
            make.centerY.equalTo(view.snp.centerY).offset(randomYOffset)
            make.height.width.equalTo(50 * Constraint.xCoeff)
        }
        randomGoldsLabel.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
            self.randomGoldsLabel.alpha = 0
        }) { _ in
            self.randomGoldsLabel.removeFromSuperview()
        }
    }

    @objc private func userPressedDoublePickAxeButton() {
            pressDoublePickAxeButtons(byUser: true)
        }

    @objc private func pressDoublePickAxeButtons(byUser: Bool = true) {
        if byUser {
            guard let currentPointsText = gameTopView.pointView.pointLabel.text,
                  let doublePickAxeCostText = doublePickAxeCost.costLabel.text,
                  let currentPoints = Int(currentPointsText),
                  let axeCost = Int(doublePickAxeCostText) else {
                return
            }
            if currentPoints >= axeCost {
                let updatedPoints = currentPoints - axeCost
                currentLeftPoints *= 2 // Update the score multiplier effect
                DispatchQueue.main.async {
                    self.gameTopView.pointView.pointLabel.text = "\(updatedPoints)"
                }
            } else {
                print("Not enough points for double pickaxe!")
            }
        } else {
            // Opponent pressed double pickaxe button
            guard let rightPointViewPointLabel = gameTimerView.rightPointView.pointLabel.text,
                  let rightViewPoint = Int(rightPointViewPointLabel) else {
                return
            }
            let doubledPoints = rightViewPoint * 2
            DispatchQueue.main.async {
                // Double the opponent's right point view
                self.gameTimerView.rightPointView.pointLabel.text = "\(doubledPoints)"
            }
        }
    }

    @objc private func userPressedBombButton() {
        guard let currentPointsText = gameTopView.pointView.pointLabel.text,
              let bombCostText = bombCost.costLabel.text,
              let currentPoints = Int(currentPointsText),
              let bombCost = Int(bombCostText) else {
            return
        }

        if currentPoints >= bombCost {
            let updatedPoints = currentPoints - bombCost
            DispatchQueue.main.async {
                self.gameTopView.pointView.pointLabel.text = "\(updatedPoints)"
            }
        }
        pressBombButtons(byUser: true)
    }

    @objc private func pressBombButtons(byUser: Bool = true) {
        if byUser {
            // Block opponent's score updates
            gameTimerView.opponentImage.image = UIImage(named: "blockUser")
            gameTimerView.rightPointView.setScoreBlocked(true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.gameTimerView.opponentImage.image = UIImage(named: "avatar")
                self?.gameTimerView.rightPointView.setScoreBlocked(false)
            }
        } else {
            // Block user's score updates
            isUserBlocked = true
            gameTimerView.userImage.image = UIImage(named: "blockUser")

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.isUserBlocked = false
                self?.gameTimerView.userImage.image = UIImage(named: "avatar")
            }
        }
    }

    @objc private func pressAutoPickAxeButtons() {
        guard let currentPointsText = gameTopView.pointView.pointLabel.text,
              let autoPickAxeCostText = autoPickAxeCost.costLabel.text,
              let currentPoints = Int(currentPointsText),
              let axeCost = Int(autoPickAxeCostText) else {
            return
        }

        if autoPickAxeTimer != nil {
            autoPickAxeTimer?.invalidate()
            autoPickAxeTimer = nil
            print("Auto-pickaxe disabled!")
            return
        }

        if currentPoints >= axeCost {
            // Deduct the cost
            let updatedPoints = currentPoints - axeCost
            self.gameTopView.pointView.pointLabel.text = "\(updatedPoints)"

            // Start the auto-pickaxe functionality
            autoPickAxeTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                self?.autoPressGameGoldButton()
            }
            print("Auto-pickaxe enabled!")
        } else {
            print("Not enough points to enable auto-pickaxe!")
        }
    }

    private func pressStartGameButton() {
        autoPickAxeTimer?.invalidate()
        autoPickAxeTimer = nil

        isUserBlocked = false
        isOpponentScoreBlocked = false
        gameTimerView.rightPointView.setScoreBlocked(false)

        // Restart the MinerGameController
        if let navigationController = navigationController {
            let newGameController = MinerGameController()
            navigationController.pushViewController(newGameController, animated: true)
        } else {
            // Fallback in case there is no navigation controller
            let newGameController = MinerGameController()
            present(newGameController, animated: true, completion: nil)
        }
    }

    private func pressContinueButton() {
        for controller in navigationController?.viewControllers ?? [] {
            if controller is MainView {
                navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
        let mainView = MainView()
        let navigationController = UINavigationController(rootViewController: mainView)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }

    private func autoPressGameGoldButton() {
        let randomIncrement = Int.random(in: 1...10)
        currentLeftPoints += randomIncrement // Update the property instead of the UI directly
    }

    private func pressContinueGameButton() {
        quitOrContinueView.isHidden = true
    }

    private func pressQuitGameButton() {
        pressContinueButton()
    }
}
