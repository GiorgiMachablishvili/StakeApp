//
//  MinerView.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class MinerView: UIView {
    
    var onStartButton: (() -> Void)?
    var onCancelButtonTapped: (() -> Void)?

    private lazy var backgroundMinerView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(20)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var gameTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "MINERS"
        view.font = UIFont.montserratBold(size: 20)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    private lazy var gameInfo: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Mine gold by clicking on the mine. You have 60 seconds to collect as much as possible! The one who collects the most wins."
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.grayLabel
        view.textAlignment = .left
        view.numberOfLines = 3
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.setImage(UIImage(named: "closeButton"), for: .normal)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(didPressCancelButton), for: .touchUpInside)
        return view
    }()

    private lazy var bonusesLabel: BonusesStringAttributed = {
        let view = BonusesStringAttributed()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelText = "BONUSES"
        return view
    }()

    private lazy var doublePickaxeView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = .whiteColor.withAlphaComponent(0.25)
        view.configureView(
            image: UIImage(named: "x2"),
            title: "X2",
            viewInfo: "Double your loot if you find a bamboo."
        )
        return view
    }()

    private lazy var bombView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = .whiteColor.withAlphaComponent(0.25)
        view.configureView(
            image: UIImage(named: "trap"),
            title: "Trap",
            viewInfo: "Set it on a cell. If your opponent gets caught, they will miss a turn."
        )
        return view
    }()

    private lazy var autoPickaxeView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = .whiteColor.withAlphaComponent(0.25)
        view.configureView(
            image: UIImage(named: "mix"),
            title: "Mix",
            viewInfo: "Mixes all closed cells, including traps and bonuses."
        )
        return view
    }()

    private lazy var startGameButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.setTitle("Start the game", for: .normal)
        view.setTitleColor(UIColor.whiteColor, for: .normal)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(backgroundMinerView)
        backgroundMinerView.addSubview(gameTitle)
        backgroundMinerView.addSubview(gameInfo)
        backgroundMinerView.addSubview(cancelButton)
        backgroundMinerView.addSubview(bonusesLabel)
        backgroundMinerView.addSubview(doublePickaxeView)
        backgroundMinerView.addSubview(bombView)
        backgroundMinerView.addSubview(autoPickaxeView)
        backgroundMinerView.addSubview(startGameButton)
    }

    private func setupConstraints() {
        backgroundMinerView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        gameTitle.snp.remakeConstraints { make in
            make.top.equalTo(backgroundMinerView.snp.top).offset(20)
            make.leading.equalTo(backgroundMinerView.snp.leading).offset(20)
            make.height.equalTo(24)
        }

        gameInfo.snp.remakeConstraints { make in
            make.top.equalTo(gameTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        cancelButton.snp.remakeConstraints { make in
            make.top.equalTo(backgroundMinerView.snp.top).offset(20)
            make.trailing.equalTo(backgroundMinerView.snp.trailing).offset(-20)
            make.height.width.equalTo(24)
        }

        bonusesLabel.snp.remakeConstraints { make in
            make.top.equalTo(gameInfo.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(15)
        }

        doublePickaxeView.snp.remakeConstraints { make in
            make.top.equalTo(bonusesLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(68)
        }

        bombView.snp.remakeConstraints { make in
            make.top.equalTo(doublePickaxeView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(68)
        }

        autoPickaxeView.snp.remakeConstraints { make in
            make.top.equalTo(bombView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(68)
        }

        startGameButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-44)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
    }

    @objc private func pressStartButton() {
        onStartButton?()
    }


    @objc private func didPressCancelButton() {
        onCancelButtonTapped?()
    }
}
