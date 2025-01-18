//
//  GameTimerScoreView.swift
//  StakeApp
//
//  Created by Gio's Mac on 19.01.25.
//

import UIKit
import SnapKit

class GameTimerScoreView: UIView {
    private lazy var timerLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "60"
        view.font = UIFont.montserratBold(size: 14)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(22)
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.buttonBackgroundColor.cgColor
        return view
    }()

    private lazy var userImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        return view
    }()

    private lazy var userName: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Tedo"
        view.font = UIFont.montserratBold(size: 13)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    private lazy var opponentImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        return view
    }()

    private lazy var opponentName: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Kote"
        view.font = UIFont.montserratBold(size: 13)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    private lazy var leftPointView: LeftGamePointView = {
        let view = LeftGamePointView()
        view.gameImage.image = UIImage(named: "gold")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var rightPointView: RightGamePointView = {
        let view = RightGamePointView()
        view.gameImage.image = UIImage(named: "gold")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private var timer: Timer?
    private var remainingSeconds: Int = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
        startTimer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(timerLabel)
        addSubview(userImage)
        addSubview(userName)
        addSubview(opponentImage)
        addSubview(opponentName)
        addSubview(leftPointView)
        addSubview(rightPointView)
    }

    private func setupConstraints() {
        timerLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(44)
        }

        userImage.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(60)
        }

        userName.snp.remakeConstraints { make in
            make.top.equalTo(userImage.snp.top)
            make.leading.equalTo(userImage.snp.trailing).offset(8)
            make.height.equalTo(15)
        }

        leftPointView.snp.remakeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(4)
            make.leading.equalTo(userImage.snp.trailing).offset(8)
            make.height.equalTo(15)
            make.width.equalTo(65)
        }

        opponentImage.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(60)
        }

        opponentName.snp.remakeConstraints { make in
            make.top.equalTo(opponentImage.snp.top)
            make.trailing.equalTo(opponentImage.snp.leading).offset(-8)
            make.height.equalTo(15)
        }

        rightPointView.snp.remakeConstraints { make in
            make.top.equalTo(opponentName.snp.bottom).offset(4)
            make.trailing.equalTo(opponentImage.snp.leading).offset(-8)
            make.height.equalTo(15)
            make.width.equalTo(65)
        }
    }

    func startTimer() {
        timer?.invalidate() // Ensure no previous timers are running
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            timerLabel.text = "\(remainingSeconds)"
        } else {
            pauseTimer()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
