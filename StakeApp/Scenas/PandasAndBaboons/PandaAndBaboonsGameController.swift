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
    private var isUserTurn: Bool = true

    private let botName = "Bot"
    private let botImageName = "avatar"
    private var botLevel = 1

    private var timerSeconds = 15
    private var moveTimer: Timer?

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
    }

    private func configureBotUI() {
        gameTimerView.opponentImage.image = UIImage(named: botImageName)
        gameTimerView.opponentName.text = botName
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
        isUserTurn = Bool.random()
        updateTurnUI()

        if !isUserTurn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Add a slight delay for a natural feel
                self.hideGameTimerView()
                self.botMakeMove()
            }
        }
    }

    private func hideGameTimerView() {
        gameStartTimerView.isHidden = true
        gameTimerView.startTimer()
    }

    //TODO: how to make this buttons or how to make real time game
    @objc private func pressX2Buttons() {
        print("press x2 button")
    }

    @objc private func pressTrapButtons() {
        print("press trap button")
    }

    @objc private func pressMixButtons() {
        print("press mix button")
    }

    @objc private func pressScannerButtons() {
        print("press scanner button")
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
        guard isUserTurn else { return } // Ignore taps if it's the bot's turn
        let cell = collectionView.cellForItem(at: indexPath) as? GameBoxCell
        guard cell?.coverView.isHidden == false else { return }

        cell?.revealImage()
    }

    private func handleMove(imageName: String, indexPath: IndexPath) {
        // Update points based on the image revealed
        if imageName == "bambuk" {
            if isUserTurn {
                gameTimerView.leftPointView.incrementPoint(by: 1)
            } else {
                gameTimerView.rightPointView.incrementPoint(by: 1)
            }
        } else if imageName == "coin" {
            gameTopView.pointView.incrementPoint(by: 1)
        }

        // Switch turns
        isUserTurn.toggle()
        updateTurnUI()

        if !isUserTurn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.botMakeMove()
            }
        } else {
            // Restart the timer for the user
//            resetTimer()
        }
    }

    private func botMakeMove() {
//        // Find unrevealed cells
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
        gameTimerView.resetTimer(to: 15)
    }

    private func updateTurnUI() {
        if isUserTurn {
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

