//
//  LeaderboardUserCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 01.02.25.
//

import UIKit
import SnapKit
import Kingfisher

class LeaderboardUserCell: UITableViewCell {
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.montserratBold(size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.makeRoundCorners(24)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "avatar") // Default image
        return imageView
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.montserratBold(size: 13)
        label.textColor = .white
        return label
    }()

    private lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.montserratBold(size: 14)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        contentView.addSubview(rankLabel)
        contentView.addSubview(userImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(pointsLabel)
    }

    private func setupConstraints() {
        rankLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16 * Constraint.xCoeff)
            make.centerY.equalToSuperview()
            make.width.equalTo(30 * Constraint.xCoeff)
        }

        userImageView.snp.remakeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(8 * Constraint.xCoeff)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48 * Constraint.yCoeff)
        }

        usernameLabel.snp.remakeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(8 * Constraint.xCoeff)
            make.centerY.equalToSuperview()
        }

        pointsLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-16 * Constraint.xCoeff)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with user: UserDataResponse, rank: Int) {
        rankLabel.text = "\(rank)"
        usernameLabel.text = user.username
        pointsLabel.text = "\(user.points)"

        if let imageUrl = URL(string: user.image) {
            userImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "avatar"))
        } else {
            userImageView.image = UIImage(named: "avatar")
        }
    }
}
