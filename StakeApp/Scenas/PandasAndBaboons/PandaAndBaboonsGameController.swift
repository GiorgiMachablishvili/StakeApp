//
//  PandaAndBaboonsGameController.swift
//  StakeApp
//
//  Created by Gio's Mac on 20.01.25.
//

import UIKit
import SnapKit

class PandaAndBaboonsGameController: UIViewController {

    private let rows = 5
    private let columns = 6
    private let boxSize: CGFloat = 66.0
    private let images = ["bambuk", "beetle", "coin", "stick", "stone", "trapR"]
    private var shuffledImages: [String] = []
    private var byUser: Bool = true

    private let botName = "Bot"
    private let botImageName = "avatar"
    private var botLevel = 1

    private var timerSeconds = 15
    private var moveTimer: Timer?

    private var isX2Active: Bool = false

    private var opponentX2PressCount = 0
    private let maxOpponentX2Presses = Int.random(in: 2...4)

    private var isOpponentBlocked: Bool = false

    var userGameHistory: [UserGameHistory] = []

    private lazy var gameCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: boxSize, height: boxSize)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GameBoxCell.self, forCellWithReuseIdentifier: "GameBoxCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()

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
        view.image = UIImage(named: "pangaGameBackground")
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var gameTimerView: GameTimerScoreView = {
        let view = GameTimerScoreView(frame: .zero)
        view.backgroundColor = .clear
        view.timerLabel.text = "timerSeconds"
        view.remainingSeconds = timerSeconds
        view.leftPointView.gameImage.image = UIImage(named: "bamboImage")
        view.rightPointView.gameImage.image = UIImage(named: "bamboImage")
        view.userImage.layer.borderWidth = 3
        view.userImage.layer.borderColor = UIColor.buttonBackgroundColor.cgColor
        view.opponentImage.layer.borderWidth = 3
        view.opponentImage.layer.borderColor = UIColor.buttonBackgroundColor.cgColor
        view.opponentName.textAlignment = .right
        view.onTimeUpdate = { [weak self] remainingSeconds in
            self?.handleTimeUpdate(remainingSeconds)
        }
        return view
    }()

    private lazy var x2Buttons: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "x2"), for: .normal)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 28
        view.backgroundColor = .buttonBackgroundColor
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressX2Buttons), for: .touchUpInside)
        return view
    }()

    private lazy var x2Cost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "1"
        return view
    }()

    private lazy var trapButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "trap"), for: .normal)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 28
        view.backgroundColor = .buttonBackgroundColor
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressTrapButtons), for: .touchUpInside)
        return view
    }()

    private lazy var trapCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "2"
        return view
    }()

    private lazy var mixButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "mix"), for: .normal)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 28
        view.backgroundColor = .buttonBackgroundColor
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressMixButtons), for: .touchUpInside)
        return view
    }()

    private lazy var mixCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "3"
        return view
    }()

    private lazy var scannerButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "scanner"), for: .normal)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 28
        view.backgroundColor = .buttonBackgroundColor
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressScannerButtons), for: .touchUpInside)
        return view
    }()

    private lazy var scannerCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "4"
        return view
    }()

    private lazy var winOrLoseView: WinOrLoseView = {
        let view = WinOrLoseView(frame: .zero)
        view.backgroundColor = UIColor(hexString: "#16171A")
        view.makeRoundCorners(20)
        view.leftPointView.gameImage.image = UIImage(named: "bamboImage")
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

        shuffledImages = generateShuffledImages()

        setup()
        setupConstraints()

        initializeTurn()
        configureBotUI()
        gameTimerView.pauseTimer()
    }

    private func setup() {
        view.addSubview(gameTopView)
        view.addSubview(gameBackgroundImage)
        gameBackgroundImage.addSubview(gameTimerView)
        gameBackgroundImage.addSubview(gameCollectionView)
        gameBackgroundImage.addSubview(x2Buttons)
        gameBackgroundImage.addSubview(trapButtons)
        gameBackgroundImage.addSubview(mixButtons)
        gameBackgroundImage.addSubview(scannerButtons)
        view.addSubview(x2Cost)
        view.addSubview(trapCost)
        view.addSubview(mixCost)
        view.addSubview(scannerCost)
        view.addSubview(winOrLoseView)
        view.addSubview(quitOrContinueView)
        view.addSubview(gameStartTimerView)
    }

    private func setupConstraints() {
        gameTopView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(104 * Constraint.yCoeff)
        }

        gameTimerView.snp.remakeConstraints { make in
            make.top.equalTo(gameTopView.snp.bottom).offset(49 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(60 * Constraint.yCoeff)
        }

        gameBackgroundImage.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(gameTopView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom).offset(-56 * Constraint.yCoeff)
        }

        gameStartTimerView.snp.remakeConstraints { make in
            make.top.equalTo(gameTopView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        gameCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(gameTimerView.snp.bottom).offset(42)
            make.leading.trailing.equalToSuperview().inset(18)
            make.bottom.equalTo(x2Buttons.snp.top).offset(-42)
        }

        x2Buttons.snp.remakeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(27 * Constraint.yCoeff)
            make.bottom.equalTo(view.snp.bottom).offset(-52)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        x2Cost.snp.remakeConstraints { make in
            make.centerX.equalTo(x2Buttons.snp.centerX)
            make.bottom.equalTo(x2Buttons.snp.bottom).offset(5 * Constraint.yCoeff)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.greaterThanOrEqualTo(34 * Constraint.xCoeff)
        }

        trapButtons.snp.remakeConstraints { make in
            make.leading.equalTo(x2Buttons.snp.trailing).offset(16 * Constraint.yCoeff)
            make.centerY.equalTo(x2Buttons.snp.centerY)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        trapCost.snp.remakeConstraints { make in
            make.centerX.equalTo(trapButtons.snp.centerX)
            make.bottom.equalTo(trapButtons.snp.bottom).offset(5 * Constraint.yCoeff)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.greaterThanOrEqualTo(34 * Constraint.xCoeff)
        }

        mixButtons.snp.remakeConstraints { make in
            make.leading.equalTo(trapButtons.snp.trailing).offset(16 * Constraint.yCoeff)
            make.centerY.equalTo(trapButtons.snp.centerY)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        mixCost.snp.remakeConstraints { make in
            make.centerX.equalTo(mixButtons.snp.centerX)
            make.bottom.equalTo(mixButtons.snp.bottom).offset(5 * Constraint.yCoeff)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.greaterThanOrEqualTo(34 * Constraint.xCoeff)
        }

        scannerButtons.snp.remakeConstraints { make in
            make.leading.equalTo(mixButtons.snp.trailing).offset(16 * Constraint.yCoeff)
            make.centerY.equalTo(mixButtons.snp.centerY)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        scannerCost.snp.remakeConstraints { make in
            make.centerX.equalTo(scannerButtons.snp.centerX)
            make.bottom.equalTo(scannerButtons.snp.bottom).offset(5 * Constraint.yCoeff)
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

    private func checkIfAllBoxesAreOpen() -> Bool {
        for index in 0..<(rows * columns) {
            let cell = gameCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? GameBoxCell
            if cell?.coverView.isHidden == false {
                return false
            }
        }
        return true
    }

    private func configureBotUI() {
        gameTimerView.opponentImage.image = UIImage(named: botImageName)
//        gameTimerView.opponentName.text = botName
        gameTimerView.opponentLevelLabel.text = "\(botLevel)"
    }

    private func generateShuffledImages() -> [String] {
        var allImages = [String]()
        for _ in 0..<(rows * columns / images.count) {
            allImages.append(contentsOf: images)
        }
        allImages.shuffle()
        return Array(allImages.prefix(rows * columns))
    }

    private func initializeTurn() {
        // Randomly determine whether it's the user's turn
        byUser = Bool.random()
        updateTurnUI()

        if !byUser {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hideGameTimerView()
                self.botMakeMove()
            }
        }
    }

    private func hideGameTimerView() {
        gameStartTimerView.isHidden = true
        gameTimerView.startTimer()
    }

    private func handleTimeUpdate(_ remainingSeconds: Int) {
        if remainingSeconds == 0 {
            print("Time's up! Switching turns.")
            // Switch turns when time runs out
            byUser.toggle()
            updateTurnUI()

            //TODO: maybe it need to delete
            // Reset and restart the timer
            resetTimer()

            if !byUser {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.botMakeMove()
                }
            } /*else {*/
//                resetTimer() // Restart the timer for the user
//            }
            return
        }
        // Implement other time-based actions like auto-pressing buttons
        if byUser {
            let randomNumber = Int.random(in: 12...14)
            if remainingSeconds == randomNumber {
                
                // Example of auto press logic for user
            }
        } else {
            // Logic for bot auto actions
        }

        //MARK: auto press bomb button
        let randomNumber = Int.random(in: 12...14)
        if remainingSeconds == randomNumber {
            if remainingSeconds == 13 {
                //MARK: Generate a random number of bomb presses (0 to 1)
                let x2PressCount = Int.random(in: 1...2)
                print("Opponent will press x2 button \(x2PressCount) time(s)")

                //MARK: Schedule the bomb presses over the remaining time
                scheduleX2Presses(count: x2PressCount, remainingTime: remainingSeconds)
            }
        }

        //MARK: auto press trap button
        let randomNumberTrap = Int.random(in: 12...14)
        if remainingSeconds == randomNumberTrap {
            if remainingSeconds == 13 {
                //MARK: Generate a random number of bomb presses (0 to 1)
                let trapPressCount = Int.random(in: 1...2)
                print("Opponent will press x2 button \(trapPressCount) time(s)")

                //MARK: Schedule the bomb presses over the remaining time
                scheduleTrapPresses(count: trapPressCount, remainingTime: remainingSeconds)
            }
        }

        //MARK: auto press mix button
        if remainingSeconds == randomNumber {
            if remainingSeconds == 12 {
                //MARK: Generate a random number of bomb presses (0 to 1)
                let mixCount = Int.random(in: 1...2)
                print("Opponent will press x2 button \(mixCount) time(s)")

                //MARK: Schedule the bomb presses over the remaining time
                scheduleMixPresses(count: mixCount, remainingTime: remainingSeconds)
            }
        }
    }

    //MARK: schedule x2 presses
    private func scheduleX2Presses(count: Int, remainingTime: Int)  {
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
                self?.pressX2Buttons()
            }
        }
    }

    //MARK: schedule trap presses
    private func scheduleTrapPresses(count: Int, remainingTime: Int)  {
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
                self?.pressTrapButtons()
            }
        }
    }

    //MARK: schedule double point presses
    private func scheduleMixPresses(count: Int, remainingTime: Int) {
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
                self?.pressMixButtons()
            }
        }
    }

    @objc private func pressX2Buttons() {
        if byUser {
            // Deduct the x2 button cost for the opponent
            guard let currentPointsText = gameTopView.pointView.pointLabel.text,
                  let x2CostText = x2Cost.costLabel.text,
                  let leftPointViewPointLabel = gameTimerView.leftPointView.pointLabel.text,
                  let leftViewPoint = Int(leftPointViewPointLabel),
                  let currentPoints = Int(currentPointsText),
                  let x2Cost = Int(x2CostText) else {
                return
            }
            // Update opponent's points
            if currentPoints >= x2Cost {
                // Deduct the x2 button cost from the user's points
                let updatedPoints = currentPoints - x2Cost
                // Double the left point view score
                let doubledPoints = leftViewPoint * 2
                DispatchQueue.main.async {
                    // Update the UI
                    self.gameTopView.pointView.pointLabel.text = "\(updatedPoints)"
                    self.gameTimerView.leftPointView.pointLabel.text = "\(doubledPoints)"
                }
            }
        } else {
            // Double the opponent's score
            guard let opponentScoreText = gameTimerView.rightPointView.pointLabel.text,
                  let opponentScore = Int(opponentScoreText) else {
                return
            }
            let doubledScore = opponentScore * 2
            DispatchQueue.main.async {
                self.gameTimerView.rightPointView.pointLabel.text = "\(doubledScore)"
            }
        }
    }

    @objc private func pressTrapButtons() {
        //TODO: how to make that opponent pressed trap button and block user for one move
        if byUser {
            guard let currentPointsText = gameTopView.pointView.pointLabel.text,
                  let trapCostText = trapCost.costLabel.text,
                  let currentPoints = Int(currentPointsText),
                  let trapCostValue = Int(trapCostText),
                  currentPoints >= trapCostValue else {
                print("Not enough points to press trap button!")
                return
            }
            // Deduct the trap button cost
            let updatedPoints = currentPoints - trapCostValue
            DispatchQueue.main.async {
                self.gameTopView.pointView.pointLabel.text = "\(updatedPoints)"
            }
            isOpponentBlocked = true
            // Apply the trap
            print("Trap button pressed: Opponent will skip their next move.")
        } 
    }

    //TODO: When reload gameCollectionView.reloadData hides open images
    @objc private func pressMixButtons() {
        if byUser {
            // Check if the user has enough points to use the Mix button
            guard let currentPointsText = gameTopView.pointView.pointLabel.text,
                  let mixCostText = mixCost.costLabel.text,
                  let currentPoints = Int(currentPointsText),
                  let mixCostValue = Int(mixCostText),
                  currentPoints >= mixCostValue else {
                print("Not enough points to press mix button!")
                return
            }

            // Deduct the cost of the Mix button
            let updatedPoints = currentPoints - mixCostValue
            DispatchQueue.main.async {
                self.gameTopView.pointView.pointLabel.text = "\(updatedPoints)"
            }

            // Separate revealed (unhidden) and hidden (covered) images
            var revealedImages: [IndexPath: String] = [:]
            var hiddenIndices: [IndexPath] = []

            for index in 0..<(rows * columns) {
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = gameCollectionView.cellForItem(at: indexPath) as? GameBoxCell {
                    if cell.coverView.isHidden { // Image is revealed
                        revealedImages[indexPath] = shuffledImages[indexPath.item]
                    } else { // Image is hidden
                        hiddenIndices.append(indexPath)
                    }
                }
            }

            // Shuffle only the hidden images
            var hiddenImages = hiddenIndices.map { shuffledImages[$0.item] }
            hiddenImages.shuffle()

            // Update `shuffledImages` for the hidden cells
            for (index, indexPath) in hiddenIndices.enumerated() {
                shuffledImages[indexPath.item] = hiddenImages[index]
            }

            // Reload only the hidden cells
            DispatchQueue.main.async {
                self.gameCollectionView.reloadItems(at: hiddenIndices)
            }

            print("Mix button pressed: Hidden images shuffled, revealed images unchanged.")
        }
    }

    @objc private func pressScannerButtons() {
        guard let currentPointsText = gameTopView.pointView.pointLabel.text,
              let scannerCostText = scannerCost.costLabel.text,
              let currentPoints = Int(currentPointsText),
              let scannerCostValue = Int(scannerCostText),
              currentPoints >= scannerCostValue else {
            print("Not enough points to press scanner button!")
            return
        }

        // Deduct cost
        let updatedPoints = currentPoints - scannerCostValue
        DispatchQueue.main.async {
            self.gameTopView.pointView.pointLabel.text = "\(updatedPoints)"
        }

        // Store initial state of coverViews
        var initialCoverViewStates: [IndexPath: Bool] = [:]
        for index in 0..<(rows * columns) {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = gameCollectionView.cellForItem(at: indexPath) as? GameBoxCell {
                initialCoverViewStates[indexPath] = cell.coverView.isHidden
                // Reveal all cover views
                cell.coverView.isHidden = true
            }
        }
        print("Scanner button pressed, revealing all cover views.")

        // Revert to initial states after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            for (indexPath, wasHidden) in initialCoverViewStates {
                if let cell = self.gameCollectionView.cellForItem(at: indexPath) as? GameBoxCell {
                    cell.coverView.isHidden = wasHidden
                }
            }
            print("Cover views reverted to their initial state after 3 seconds.")
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

    private func pressStartGameButton() {
        gameTimerView.rightPointView.setScoreBlocked(false)

        // Restart the MinerGameController
        if let navigationController = navigationController {
            let newGameController = PandaAndBaboonsGameController()
            navigationController.pushViewController(newGameController, animated: true)
        } else {
            // Fallback in case there is no navigation controller
            let newGameController = PandaAndBaboonsGameController()
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

    private func quitOrContinueGame() {
        quitOrContinueView.isHidden = false
    }

    private func pressContinueGameButton() {
        quitOrContinueView.isHidden = true
    }

    private func pressQuitGameButton() {
        pressContinueButton()
    }
}

extension PandaAndBaboonsGameController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows * columns
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameBoxCell", for: indexPath) as! GameBoxCell
        let imageName = shuffledImages[indexPath.item]
        cell.configure(with: imageName)
        cell.onImageRevealed = { [weak self] in
            guard let self = self else { return }
            self.handleMove(imageName: imageName, indexPath: indexPath)
        }
        cell.resetTimerCallback = { [weak self] in
            guard let self = self else { return }
            self.resetTimer()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard byUser else { return } // Ignore taps if it's the bot's turn
        let cell = collectionView.cellForItem(at: indexPath) as? GameBoxCell
        guard cell?.coverView.isHidden == false else { return }

        cell?.revealImage()
    }

    private func handleMove(imageName: String, indexPath: IndexPath) {
        // Update points based on the image revealed
        if imageName == "bambuk" {
            if byUser {
                gameTimerView.leftPointView.incrementPoint(by: 1)
            } else {
                gameTimerView.rightPointView.incrementPoint(by: 1)
            }
        }

        // Increment points only when the user opens "coin"
        if imageName == "coin" && byUser == true {
            gameTopView.pointView.incrementPoint(by: 1)
        }

        //TODO: when opponent open trapR user is not blocked, it should block
        if imageName == "trapR" {
            // Block the other player for one move
            if byUser {
                isOpponentBlocked = true
                print("Trap revealed! Opponent will skip their next move.")
            } else {
                gameCollectionView.isUserInteractionEnabled = false // Disable user interaction
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.byUser = false // Ensure the user is blocked for one move
                    self.gameCollectionView.isUserInteractionEnabled = true // Re-enable after the move
                    self.botMakeMove()
                }
            }
        }

        //MARK: here should make get method
        //MARK: Check if all boxes are open
        if checkIfAllBoxesAreOpen() {
            winOrLoseView.isHidden = false

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
                    time: Int(currentTimeString),
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

            return
        }

        //MARK: Switch turns
        byUser.toggle()
        updateTurnUI()

        if !byUser {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.botMakeMove()
            }
        } else {
            // Restart the timer for the user
            resetTimer()
        }
    }

    private func botMakeMove() {
        // Check if the opponent is blocked
        if isOpponentBlocked {
            print("Opponent's move skipped due to trap.")
            isOpponentBlocked = false
            byUser = true
            updateTurnUI()
            return
        }

        // Find unrevealed cells
        let availableIndices = shuffledImages.indices.filter {
            let cell = gameCollectionView.cellForItem(at: IndexPath(item: $0, section: 0)) as? GameBoxCell
            return cell?.coverView.isHidden == false
        }

        guard let randomIndex = availableIndices.randomElement() else { return }

        // Bot reveals the box
        let imageName = shuffledImages[randomIndex]
        if let cell = gameCollectionView.cellForItem(at: IndexPath(item: randomIndex, section: 0)) as? GameBoxCell {
            cell.revealImage()
        }
    }

    private func resetTimer() {
        gameTimerView.resetTimer(to: timerSeconds)
    }

    private func updateTurnUI() {
        if byUser {
            gameTimerView.userImage.layer.borderColor = UIColor.buttonBackgroundColor.cgColor
            gameTimerView.opponentImage.layer.borderColor = UIColor.userImageGrayBorderColor.cgColor
            gameTimerView.leftArrow.isHidden = false
            gameTimerView.rightArrow.isHidden = true
            gameCollectionView.isUserInteractionEnabled = true
        } else {
            gameTimerView.userImage.layer.borderColor = UIColor.userImageGrayBorderColor.cgColor
            gameTimerView.opponentImage.layer.borderColor = UIColor.buttonBackgroundColor.cgColor
            gameTimerView.rightArrow.isHidden = false
            gameTimerView.leftArrow.isHidden = true
            gameCollectionView.isUserInteractionEnabled = false
        }
    }
}

