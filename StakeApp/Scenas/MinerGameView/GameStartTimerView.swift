//
//  GameStartTimerView.swift
//  StakeApp
//
//  Created by Gio's Mac on 19.01.25.
//

import UIKit
import SnapKit

class GameStartTimerView: UIView {

    var timerDidFinish: (() -> Void)?

    private lazy var backgroundGameStartTimerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.8)
        return view
    }()

    private lazy var timerLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "3"
        view.font = UIFont.montserratBold(size: 60)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        view.backgroundColor = UIColor.clear
        view.makeRoundCorners(22)
        return view
    }()

    private var timer: Timer?
    private var remainingSeconds: Int = 3

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
        addSubview(backgroundGameStartTimerView)
        backgroundGameStartTimerView.addSubview(timerLabel)
    }

    private func setupConstraints() {
        backgroundGameStartTimerView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        timerLabel.snp.remakeConstraints { make in
            make.center.equalTo(backgroundGameStartTimerView.snp.center)
            make.height.equalTo(73 * Constraint.yCoeff)
            make.width.equalTo(36 * Constraint.xCoeff)
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            timerLabel.text = "\(remainingSeconds)"
        } else {
            timer?.invalidate()
            timer = nil
            timerDidFinish?()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
