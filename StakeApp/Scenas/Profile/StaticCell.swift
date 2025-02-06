//
//  StaticCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class StaticCell: UICollectionViewCell {
    private lazy var bonusesLabel: BonusesStringAttributed = {
        let view = BonusesStringAttributed()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelText = "STATISTICS"
        return view
    }()

    private lazy var backgroundStatisticView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(20)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var gamePlayedTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Games played"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.whiteColor.withAlphaComponent(0.33)
        view.textAlignment = .right
        return view
    }()

    private lazy var gamePlayedScore: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "2"
        view.font = UIFont.montserratBold(size: 14)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .right
        return view
    }()

    private lazy var verticalLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .whiteColor.withAlphaComponent(0.3)
        return view
    }()

    private lazy var gameWonTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Games won"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.whiteColor.withAlphaComponent(0.33)
        view.textAlignment = .left
        return view
    }()

    private lazy var gameWonScore: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "2"
        view.font = UIFont.montserratBold(size: 14)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .right
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
        addSubview(bonusesLabel)
        addSubview(backgroundStatisticView)
        backgroundStatisticView.addSubview(gamePlayedTitle)
        backgroundStatisticView.addSubview(gamePlayedScore)
        backgroundStatisticView.addSubview(verticalLine)
        backgroundStatisticView.addSubview(gameWonTitle)
        backgroundStatisticView.addSubview(gameWonScore)
    }

    private func setupConstraints() {
        bonusesLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(2 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        backgroundStatisticView.snp.remakeConstraints { make in
            make.top.equalTo(bonusesLabel.snp.bottom).offset(24 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(69 * Constraint.yCoeff)
        }

        verticalLine.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(37 * Constraint.yCoeff)
            make.width.equalTo(0.5 * Constraint.xCoeff)
        }

        gamePlayedTitle.snp.remakeConstraints { make in
            make.top.equalTo(verticalLine.snp.top)
            make.trailing.equalTo(verticalLine.snp.leading).offset(-12 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        gamePlayedScore.snp.remakeConstraints { make in
            make.bottom.equalTo(verticalLine.snp.bottom)
            make.trailing.equalTo(verticalLine.snp.leading).offset(-12 * Constraint.xCoeff)
            make.height.equalTo(17 * Constraint.yCoeff)
        }

        gameWonTitle.snp.remakeConstraints { make in
            make.top.equalTo(verticalLine.snp.top)
            make.leading.equalTo(verticalLine.snp.trailing).offset(12 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        gameWonScore.snp.remakeConstraints { make in
            make.bottom.equalTo(verticalLine.snp.bottom)
            make.leading.equalTo(verticalLine.snp.trailing).offset(12 * Constraint.xCoeff)
            make.height.equalTo(17 * Constraint.yCoeff)
        }
    }

    func configure(user data: UserGameStats) {
        gamePlayedScore.text = "\(data.gamePlayedCount)"
        gameWonScore.text = "\(data.gamesWon)"
    }
}
