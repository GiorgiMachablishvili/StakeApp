//
//  LeaderBoardUserCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 01.02.25.
//

import UIKit
import SnapKit
import Kingfisher

class LeaderBoardUserCell: UITableViewCell {
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
        imageView.image = UIImage(named: "avatar")
        return imageView
    }()

    lazy var userLevelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.montserratMedium(size: 13)
        view.backgroundColor = .userImageGrayBorderColor
        view.textColor = .whiteColor
        view.textAlignment = .center
        view.makeRoundCorners(10)
        view.text = "1"
        return view
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

        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        contentView.addSubview(rankLabel)
        contentView.addSubview(userImageView)
        contentView.addSubview(userLevelLabel)
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

        userLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(userImageView.snp.top).offset(30 * Constraint.yCoeff)
            make.leading.equalTo(userImageView.snp.leading).offset(30 * Constraint.xCoeff)
            make.height.width.equalTo(20 * Constraint.yCoeff)
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

    func configure(with user: LeaderBoardStatic, rank: Int) {
        rankLabel.text = "\(rank)"
        usernameLabel.text = user.username
        pointsLabel.text = "\(user.points)"
        userLevelLabel.text = "\(user.level)"

        if let imageUrl = URL(string: user.image) {
            userImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "avatar"))
        } else {
            userImageView.image = UIImage(named: "avatar")
        }
    }
}
