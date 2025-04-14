//
//  DailyBonusViewCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit

class DailyBonusViewCell: UICollectionViewCell {
    private var timer: Timer?
    private var remainingTime: TimeInterval = 0
    var didPressGetDailyBonus: (() -> Void)?

    private lazy var backgroundTopView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var consoleImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "pandapandu")
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
        view.text = "--:--:--" // Default state
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
        view.setTitle("Get Bonus", for: .normal)
        view.setTitleColor(UIColor.whiteColor, for: .normal)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(pressGetDailyBonus), for: .touchUpInside)
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
            make.leading.equalTo(backgroundTopView.snp.leading).offset(-140 * Constraint.xCoeff)
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

    /// ✅ **Starts the countdown with a given timestamp from the backend**
    func startBonusTimer(with nextBonusTimestamp: TimeInterval) {
        let currentTime = Date().timeIntervalSince1970
        remainingTime = max(nextBonusTimestamp - currentTime, 0)

        print("🕒 Timer starts with remainingTime: \(remainingTime) seconds")

        // Invalidate existing timer
        timer?.invalidate()

        // Update UI immediately
        updateTimer()

        // Start countdown timer
        if remainingTime > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateTimer()
            }
        }
    }

    /// ✅ **Updates the timer every second**
    private func updateTimer() {
        guard remainingTime > 0 else {
            timer?.invalidate()
            timer = nil
            DispatchQueue.main.async {
                self.timerLabel.text = "00:00:00"
                self.getDailyBonus.isUserInteractionEnabled = true
                self.getDailyBonus.backgroundColor = UIColor.systemGreen
                self.getDailyBonus.setTitleColor(UIColor.black, for: .normal)
                print("✅ Timer finished, enabling Get Bonus button")
            }
            return
        }

        remainingTime -= 1
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)

        DispatchQueue.main.async {
            self.timerLabel.text = formattedTime
        }
    }

    /// ✅ **Prevents flickering issue when the cell is reused**
    override func prepareForReuse() {
        super.prepareForReuse()

        // Prevent timer reset if a valid countdown is running
        if remainingTime > 0 {
            print("🔄 Cell reused with active timer, keeping the countdown running.")
            return
        }

        timer?.invalidate()
        timer = nil
        remainingTime = 0

        DispatchQueue.main.async {
            self.timerLabel.text = "--:--:--"
        }

        getDailyBonus.isUserInteractionEnabled = false
        getDailyBonus.backgroundColor = UIColor.buttonBackgroundColor
        getDailyBonus.setTitleColor(UIColor.whiteColor, for: .normal)
    }

    /// ✅ **Handles "Get Bonus" button click**
    @objc private func pressGetDailyBonus() {
        print("✅ GetDailyBonus button pressed")
//        didPressGetDailyBonus?()

        // Disable button until next bonus time
        getDailyBonus.isUserInteractionEnabled = false
        getDailyBonus.backgroundColor = UIColor.buttonBackgroundColor
        getDailyBonus.setTitleColor(UIColor.whiteColor, for: .normal)

        // Request the next bonus time from the backend
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.didPressGetDailyBonus?()
        }
    }

    func configure(with data: BonusTimer) {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        if let date = isoFormatter.date(from: data.nextBonusTime) {
            let nextBonusTimestamp = date.timeIntervalSince1970
            startBonusTimer(with: nextBonusTimestamp)
        } else {
            print("❌ Failed to parse next_bonus_time: \(data.nextBonusTime)")
        }
    }

    func configureDailyBonus(with data: DailyBonusPost) {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        if let date = isoFormatter.date(from: data.nextBonusTime) {
            let nextBonusTimestamp = date.timeIntervalSince1970
            startBonusTimer(with: nextBonusTimestamp)
        } else {
            print("❌ Failed to parse next_bonus_time: \(data.nextBonusTime)")
        }
    }

}
