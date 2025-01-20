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
        view.leftPointView.gameImage.image = UIImage(named: "bamboImage")
        view.rightPointView.gameImage.image = UIImage(named: "bamboImage")
        return view
    }()

    private lazy var x2Buttons: UIButton = {
        let view = UIButton(frame: .zero)
        view.gameBonusButton(gameBonusImage: UIImage(named: "x2"))
        view.contentMode = .scaleAspectFit
//        view.addTarget(self, action: #selector(pressDoublePickAxeButtons), for: .touchUpInside)
        return view
    }()

    private lazy var x2Cost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "1"
        return view
    }()

    private lazy var trapButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.gameBonusButton(gameBonusImage: UIImage(named: "trap"))
        view.contentMode = .scaleAspectFit
//        view.addTarget(self, action: #selector(pressDoublePickAxeButtons), for: .touchUpInside)
        return view
    }()

    private lazy var trapCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "2"
        return view
    }()

    private lazy var mixButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.gameBonusButton(gameBonusImage: UIImage(named: "mix"))
        view.contentMode = .scaleAspectFit
//        view.addTarget(self, action: #selector(pressDoublePickAxeButtons), for: .touchUpInside)
        return view
    }()

    private lazy var mixCost: BonusCostView = {
        let view = BonusCostView()
        view.costLabel.text = "3"
        return view
    }()

    private lazy var scannerButtons: UIButton = {
        let view = UIButton(frame: .zero)
        view.gameBonusButton(gameBonusImage: UIImage(named: "scanner"))
        view.contentMode = .scaleAspectFit
//        view.addTarget(self, action: #selector(pressDoublePickAxeButtons), for: .touchUpInside)
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

    private func generateShuffledImages() -> [String] {
        var allImages = [String]()
        for _ in 0..<(rows * columns / images.count) {
            allImages.append(contentsOf: images)
        }
        allImages.shuffle()
        return Array(allImages.prefix(rows * columns))
    }

    private func hideGameTimerView() {
        gameStartTimerView.isHidden = true
        gameTimerView.startTimer()
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
        
//        cell.onImageRevealed = { [weak self] in
//            self?.gameTimerView.leftPointView.incrementPoint(by: 1)
        //        }

        cell.onImageRevealed = { [weak self] in
            if imageName == "bambuk" {
                self?.gameTimerView.leftPointView.incrementPoint(by: 1)
            }
        }
        return cell
    }
}
