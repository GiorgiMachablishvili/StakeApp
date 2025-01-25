//
//  DailyBonusViewCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit

class DailyBonusViewCell: UICollectionViewCell {
    private lazy var backgroundTopView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var consoleImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "signinViewImage")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var bonusTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Get your daily bonus"
        view.numberOfLines = 2
        view.font = UIFont.montserratBold(size: 16)
        view.textColor = .whiteColor
        view.textAlignment = .left
        return view
    }()

    private lazy var timerLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "24:00:00"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor(hexString: "#687CFF")
        view.backgroundColor = UIColor(hexString: "#687CFF29").withAlphaComponent(0.1)
        view.textAlignment = .center
        view.makeRoundCorners(8)
        return view
    }()

    private lazy var getDailyBonus: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.setTitle("Get Bonus ", for: .normal)
        view.setTitleColor(UIColor.whiteColor, for: .normal)
        view.makeRoundCorners(16)
        return view
    }()

    //TODO: how to make Timer work even when the user is turned off
    private var timer: Timer?
    private var remainingTime: TimeInterval = 86400

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
        addSubview(backgroundTopView)
        backgroundTopView.addSubview(consoleImage)
        backgroundTopView.addSubview(bonusTitle)
        backgroundTopView.addSubview(timerLabel)
        backgroundTopView.addSubview(getDailyBonus)
    }

    private func setupConstraints() {
        backgroundTopView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        consoleImage.snp.remakeConstraints { make in
            make.top.equalTo(backgroundTopView.snp.top).offset(-20 * Constraint.yCoeff)
            make.leading.equalTo(backgroundTopView.snp.leading).offset(-200 * Constraint.xCoeff)
            make.bottom.equalTo(backgroundTopView.snp.bottom).offset(20 * Constraint.yCoeff)
            make.width.equalTo(430 * Constraint.xCoeff)
        }

        bonusTitle.snp.remakeConstraints { make in
            make.top.equalTo(backgroundTopView.snp.top).offset(17 * Constraint.yCoeff)
            make.trailing.equalTo(backgroundTopView.snp.trailing).offset(-56 * Constraint.xCoeff)
            make.height.equalTo(40 * Constraint.yCoeff)
            make.width.equalTo(123 * Constraint.xCoeff)
        }

        timerLabel.snp.remakeConstraints { make in
            make.top.equalTo(bonusTitle.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.equalTo(bonusTitle.snp.leading)
            make.height.equalTo(25 * Constraint.yCoeff)
            make.width.equalTo(78 * Constraint.xCoeff)
        }

        getDailyBonus.snp.remakeConstraints { make in
            make.trailing.equalTo(backgroundTopView.snp.trailing).offset(-16 * Constraint.xCoeff)
            make.bottom.equalTo(backgroundTopView.snp.bottom).offset(-16 * Constraint.yCoeff)
            make.height.equalTo(39 * Constraint.yCoeff)
            make.width.equalTo(163 * Constraint.xCoeff)
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    private func updateTimer() {
        guard remainingTime > 0 else {
            timer?.invalidate()
            timer = nil
            timerLabel.text = "00:00:00" // Timer finished
            return
        }

        remainingTime -= 1
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
        remainingTime = 86400 // Reset to 24 hours
        timerLabel.text = "00:00:00"
    }
}
