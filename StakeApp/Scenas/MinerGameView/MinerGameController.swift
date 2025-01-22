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

    private var botPointsTimeInterval = 0.2

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
        return view
    }()

    private lazy var doublePickAxeButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "doublePickAxe"), for: .normal)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 28
        view.backgroundColor = .buttonBackgroundColor
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(pressDoublePickAxeButtons), for: .touchUpInside)
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
        view.addTarget(self, action: #selector(pressBombButtons), for: .touchUpInside)
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

        gameTimerView.pauseTimer()
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

        if userPoints > opponentCost {
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
    }

    @objc func pressGameGoldButton () {
        let randomNumber = Int.random(in: 1...10)
        currentGoldPoints += randomNumber
        gameTimerView.leftPointView.pointLabel.text = "\(currentGoldPoints)"
        randomGoldsLabel.pointLabel.text = "+ \(randomNumber)"
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

    //TODO: when pressAutoPickAxeButtons is pressed and press pressDoublePickAxeButtons does not continues from doubled points
    //TODO: when pressAutoPickAxeButtons is pressed and press pressGameGoldButton does not continue from doubled points
    @objc private func pressDoublePickAxeButtons() {
        guard let currentPointsText = gameTopView.pointView.pointLabel.text,
              let doublePickAxeCostText = doublePickAxeCost.costLabel.text,
              let leftPointViewPointLabel = gameTimerView.leftPointView.pointLabel.text,
              let leftViewPoint = Int(leftPointViewPointLabel),
              let currentPoints = Int(currentPointsText),
              let axeCost = Int(doublePickAxeCostText) else {
            return
        }
        if currentPoints >= axeCost {
            let updatedPoints = currentPoints - axeCost
            let doubledPoints = leftViewPoint * 2
            DispatchQueue.main.async {
                self.gameTopView.pointView.pointLabel.text = "\(updatedPoints)"
                self.gameTimerView.leftPointView.pointLabel.text = "\(doubledPoints)"
            }
        } else {
            print("Not enough points!")
        }
    }

    @objc private func pressBombButtons() {
        gameTimerView.opponentImage.image = UIImage(named: "blockUser")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.gameTimerView.opponentImage.image = UIImage(named: "avatar")
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
        guard let leftPointViewPointLabel = gameTimerView.leftPointView.pointLabel.text,
              let leftViewPoint = Int(leftPointViewPointLabel) else {
            return
        }

        currentGoldPoints += randomNumber
        DispatchQueue.main.async {
            self.gameTimerView.leftPointView.pointLabel.text = "\(self.currentGoldPoints)"
        }
    }

    private func pressContinueGameButton() {
        winOrLoseView.isHidden = true
    }

    private func pressQuitGameButton() {
        //TODO: make quit from game
        print("quit from game")
    }
}
