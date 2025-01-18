//
//  MinerGameController.swift
//  StakeApp
//
//  Created by Gio's Mac on 18.01.25.
//

import UIKit
import SnapKit

class MinerGameController: UIViewController {
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
        return view
    }()

    private lazy var gameGoldImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "goldenBall")
        return view
    }()

    private lazy var gameTimerView: GameTimerScoreView = {
        let view = GameTimerScoreView(frame: .zero)
        view.backgroundColor = .clear
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
        gameBackgroundImage.addSubview(gameGoldImage)
        gameBackgroundImage.addSubview(gameTimerView)
        view.addSubview(gameStartTimerView)
    }

    private func setupConstraints() {
        gameTopView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(104)
        }

        gameStartTimerView.snp.remakeConstraints { make in
            make.top.equalTo(gameTopView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        gameBackgroundImage.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(gameTopView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom).offset(-66)
        }

        gameGoldImage.snp.remakeConstraints { make in
            make.center.equalTo(gameBackgroundImage.snp.center)
            make.height.width.equalTo(280)
        }

        gameTimerView.snp.remakeConstraints { make in
            make.top.equalTo(gameTopView.snp.bottom).offset(49)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
    }

    private func hideGameTimerView() {
        gameStartTimerView.isHidden = true
        gameTimerView.startTimer()
    }
}
