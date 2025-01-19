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
        }
        return view
    }()

    private lazy var doublePickAxeButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.gameBonusButton(gameBonusImage: UIImage(named: "doublePickAxe"))
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
        view.gameBonusButton(gameBonusImage: UIImage(named: "bomb"))
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var bombCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "5"
        return view
    }()

    private lazy var autoPickAxeButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.gameBonusButton(gameBonusImage: UIImage(named: "autoPickAxe"))
        view.contentMode = .scaleAspectFit
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

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    private func hideGameTimerView() {
        gameStartTimerView.isHidden = true
        gameTimerView.startTimer()
    }

    private func makeGameGoldButtonUnenabled() {
        gameBackgroundImage.isUserInteractionEnabled = false

        //TODO: what happens in case draw? 
        guard let userPointsText = gameTimerView.leftPointView.pointLabel.text,
              let opponentCostText = gameTimerView.rightPointView.pointLabel.text,
              let userPoints = Int(userPointsText),
              let opponentCost = Int(opponentCostText) else {
            return
        }
        if userPoints > opponentCost {
            winOrLoseView.winOrLoseLabel.text = "WIN!"
            winOrLoseView.bonusButton.isHidden = false
            winOrLoseView.bonusPoints.isHidden = false
            winOrLoseView.expButton.isHidden = false
            winOrLoseView.expPoints.isHidden = false
            winOrLoseView.isHidden = false
        } else {
            winOrLoseView.winOrLoseLabel.text = "LOSE"
            winOrLoseView.winOrLoseLabel.textColor = .red
            winOrLoseView.redExpButton.isHidden = false
            winOrLoseView.redExpPoints.isHidden = false
            winOrLoseView.isHidden = false
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

    //TODO: I cant press button
    @objc private func pressDoublePickAxeButtons() {
        print("press Double PickAxe Buttons ")
        guard let currentPointsText = gameTopView.pointView.pointLabel.text,
              let doublePickAxeCostText = doublePickAxeCost.costLabel.text,
              let currentPoints = Int(currentPointsText),
              let axeCost = Int(doublePickAxeCostText) else {
            return
        }
        if currentPoints >= axeCost {
            let updatedPoints = currentPoints - axeCost

            gameTopView.pointView.pointLabel.text = "\(updatedPoints)"
        } else {
            print("Not enough points!")
        }
    }

    private func pressStartGameButton() {
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
}
