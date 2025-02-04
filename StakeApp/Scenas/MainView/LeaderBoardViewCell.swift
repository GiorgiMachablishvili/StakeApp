//
//  LeaderBoardViewCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit
import Kingfisher

class LeaderBoardViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {

    private lazy var bonusesLabel: BonusesStringAttributed = {
        let view = BonusesStringAttributed()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelText = "LEADER BOARD"
        return view
    }()

    private lazy var leaderboardTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(LeaderBoardUserCell.self, forCellReuseIdentifier: "LeaderBoardUserCell")
        return view
    }()

    var leaderboardUsers: [LeaderBoardStatic] = [] {
        didSet {
            leaderboardTableView.reloadData()
        }
    }

    private var currentUserId: Int? {
        return UserDefaults.standard.value(forKey: "userId") as? Int
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
        addSubview(bonusesLabel)
        addSubview(leaderboardTableView)
    }

    private func setupConstraints() {
        bonusesLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(2 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        leaderboardTableView.snp.remakeConstraints { make in
            make.top.equalTo(bonusesLabel.snp.bottom).offset(16 * Constraint.yCoeff)
            make.leading.trailing.bottom.equalToSuperview().inset(16 * Constraint.xCoeff)
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBoardUserCell", for: indexPath) as? LeaderBoardUserCell else {
            return UITableViewCell()
        }

        let user = leaderboardUsers[indexPath.row]
        let isCurrentUser = (user.id == currentUserId)
        cell.configure(with: user, rank: indexPath.row + 1, isCurrentUser: isCurrentUser)
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 * Constraint.yCoeff
    }
}
