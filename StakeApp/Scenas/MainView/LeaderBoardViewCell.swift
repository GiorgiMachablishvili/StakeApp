//
//  LeaderBoardViewCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit


class LeaderBoardViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    private lazy var leaderBoardImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "leaderBoard")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var leaderboardTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LeaderboardUserCell.self, forCellReuseIdentifier: "LeaderboardUserCell")
        return tableView
    }()

    var leaderboardUsers: [UserDataResponse] = [] {
        didSet {
            leaderboardTableView.reloadData()
        }
    }

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
        addSubview(leaderboardTableView)
    }

    private func setupConstraints() {
        leaderBoardImageView.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(2 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        leaderboardTableView.snp.remakeConstraints { make in
            make.top.equalTo(leaderBoardImageView.snp.bottom).offset(16 * Constraint.yCoeff)
            make.leading.trailing.bottom.equalToSuperview().inset(16 * Constraint.xCoeff)
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardUserCell", for: indexPath) as? LeaderboardUserCell else {
            return UITableViewCell()
        }

        let user = leaderboardUsers[indexPath.row]
        cell.configure(with: user, rank: indexPath.row + 1)
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 * Constraint.yCoeff // Adjust height as needed
    }
}

//class LeaderBoardViewCell: UICollectionViewCell {
//
//    private lazy var leaderBoardImageView: UIImageView = {
//        let view = UIImageView(frame: .zero)
//        view.image = UIImage(named: "leaderBoard")
//        view.contentMode = .scaleAspectFit
//        return view
//    }()
//
//    private lazy var backgroundLeaderBoardView: LeaderBoardView = {
//        let view = LeaderBoardView()
//        view.backgroundColor = UIColor.clear
//        return view
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//        setupConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setup() {
//        addSubview(leaderBoardImageView)
//        addSubview(backgroundLeaderBoardView)
//    }
//
//    private func setupConstraints() {
//        leaderBoardImageView.snp.remakeConstraints { make in
//            make.top.equalTo(snp.top).offset(2 * Constraint.yCoeff)
//            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
//            make.height.equalTo(15 * Constraint.yCoeff)
//        }
//
//        backgroundLeaderBoardView.snp.remakeConstraints { make in
//            make.top.equalTo(leaderBoardImageView.snp.bottom).offset(16 * Constraint.yCoeff)
//            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
//            make.height.equalTo(64 * Constraint.yCoeff)
//        }
//    }
//
//}
