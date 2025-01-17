//
//  LeaderBoardView.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class LeaderBoardView: UIView {
    private lazy var backgroundLeaderBoardView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        view.makeRoundCorners(16)
        return view
    }()

    private lazy var ratingNumber: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "1"
        view.font = UIFont.montserratBold(size: 14)
        view.textColor = .whiteColor
        view.textAlignment = .center
        return view
    }()

    private lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Steve"
        view.font = UIFont.montserratBold(size: 13)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    private lazy var expLabel: UILabel = {
        let view = UILabel()
        view.attributedText = createExpAttributedString()
        view.numberOfLines = 1
        view.textAlignment = .left
        view.isHidden = true
        return view
    }()

    private lazy var pointLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "1420"
        view.font = UIFont.montserratBold(size: 14)
        view.textColor = .whiteColor
        view.textAlignment = .center
        return view
    }()

    private lazy var gameConcoleImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "consollerImage")
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    private func setup() {
        addSubview(backgroundLeaderBoardView)
        backgroundLeaderBoardView.addSubview(ratingNumber)
        backgroundLeaderBoardView.addSubview(workoutImage)
        backgroundLeaderBoardView.addSubview(nameLabel)
        backgroundLeaderBoardView.addSubview(expLabel)
        backgroundLeaderBoardView.addSubview(pointLabel)
        backgroundLeaderBoardView.addSubview(gameConcoleImage)
    }

    private func setupConstraints() {
        backgroundLeaderBoardView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        ratingNumber.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundLeaderBoardView.snp.centerY)
            make.leading.equalTo(backgroundLeaderBoardView.snp.leading).offset(12)
            make.height.equalTo(17)
            make.width.equalTo(30)
        }

        workoutImage.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundLeaderBoardView.snp.centerY)
            make.leading.equalTo(ratingNumber.snp.trailing).offset(8)
            make.height.width.equalTo(48)
        }

        nameLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundLeaderBoardView.snp.centerY)
            make.leading.equalTo(workoutImage.snp.trailing).offset(8)
            make.height.equalTo(16)
        }

        expLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundLeaderBoardView.snp.centerY)
            make.leading.equalTo(workoutImage.snp.trailing).offset(8)
            make.height.equalTo(16)
        }

        pointLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundLeaderBoardView.snp.centerY)
            make.trailing.equalTo(backgroundLeaderBoardView.snp.trailing).offset(-52)
            make.height.equalTo(17)
            make.width.equalTo(40)
        }

        gameConcoleImage.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundLeaderBoardView.snp.centerY)
            make.leading.equalTo(pointLabel.snp.trailing).offset(16)
            make.height.width.equalTo(24)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createExpAttributedString() -> NSAttributedString {
        let expAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratMedium(size: 10),
            .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)
        ]
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratMedium(size: 10),
            .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)
        ]
        // Create the attributed strings
        let expString = NSAttributedString(string: "EXP ", attributes: expAttributes)
        let numberString = NSAttributedString(string: "0/20", attributes: numberAttributes)
        // Combine the two strings
        let combinedString = NSMutableAttributedString()
        combinedString.append(expString)
        combinedString.append(numberString)
        return combinedString
    }

}
