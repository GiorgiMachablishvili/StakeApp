//
//  LeaderBoardCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class LeaderBoardCell: UICollectionViewCell {

    private lazy var bonusesLabel: BonusesStringAttributed = {
        let view = BonusesStringAttributed()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelText = "LEADER BOARD"
        return view
    }()

    private lazy var backgroundLeaderBoardView: LeaderBoardView = {
        let view = LeaderBoardView()
        view.backgroundColor = UIColor.clear
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
        addSubview(backgroundLeaderBoardView)

    }

    private func setupConstraints() {
        bonusesLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(2)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }

        backgroundLeaderBoardView.snp.remakeConstraints { make in
            make.top.equalTo(bonusesLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }

    }
}

