//
//  LeaderBoardViewCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class LeaderBoardViewCell: UICollectionViewCell {

    private lazy var leaderBoardImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "leaderBoard")
        view.contentMode = .scaleAspectFit
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
        addSubview(leaderBoardImageView)
        addSubview(backgroundLeaderBoardView)

    }

    private func setupConstraints() {
        leaderBoardImageView.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(2)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }

        backgroundLeaderBoardView.snp.remakeConstraints { make in
            make.top.equalTo(leaderBoardImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }

    }
}
