//
//  TopViewCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit
import Kingfisher

class TopViewCell: UICollectionViewCell {
    private lazy var backgroundTopView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = UIColor.titlesBlack
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

//    private lazy var userLevelLabel: ExpLabel = {
//        let view = ExpLabel(frame: .zero)
//        return view
//    }()

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

    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = ""
        view.font = UIFont.montserratBold(size: 13)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    lazy var expLabel: UILabel = {
        let view = UILabel()
        view.attributedText = createExpAttributedString()
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()

    private lazy var pointView: PointsView = {
        let view = PointsView()
        view.backgroundColor = .pointViewColor
        view.makeRoundCorners(16)
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
        backgroundTopView.addSubview(workoutImage)
        backgroundTopView.addSubview(userLevelLabel)
        backgroundTopView.addSubview(nameLabel)
        backgroundTopView.addSubview(expLabel)
        backgroundTopView.addSubview(pointView)
    }

    private func setupConstraints() {
        backgroundTopView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(48 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(16 * Constraint.xCoeff)
            make.height.width.equalTo(48 * Constraint.yCoeff)
        }

        userLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.top).offset(30 * Constraint.yCoeff)
            make.leading.equalTo(workoutImage.snp.leading).offset(30 * Constraint.xCoeff)
            make.height.width.equalTo(20 * Constraint.yCoeff)
        }

        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.top).offset(9 * Constraint.yCoeff)
            make.leading.equalTo(workoutImage.snp.trailing).offset(8 * Constraint.xCoeff)
            make.height.equalTo(16 * Constraint.yCoeff)
        }

        expLabel.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2 * Constraint.yCoeff)
            make.leading.equalTo(workoutImage.snp.trailing).offset(8 * Constraint.xCoeff)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        pointView.snp.remakeConstraints { make in
            make.centerY.equalTo(workoutImage.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-16 * Constraint.xCoeff)
            make.height.equalTo(40 * Constraint.yCoeff)
            make.width.equalTo(85 * Constraint.xCoeff)
        }
    }

    func createExpAttributedString() -> NSAttributedString {
        let expAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratMedium(size: 10),
            .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)
        ]
        let numberExp: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratMedium(size: 10),
            .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)
        ]
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratMedium(size: 10),
            .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)
        ]
        // Create the attributed strings
        let expString = NSAttributedString(string: "EXP ", attributes: expAttributes)
        let numberOfExp = NSAttributedString(string: "0", attributes: numberExp)
        let numberString = NSAttributedString(string: "/20", attributes: numberAttributes)
        // Combine the two strings
        let combinedString = NSMutableAttributedString()
        combinedString.append(expString)
        combinedString.append(numberOfExp)
        combinedString.append(numberString)
        return combinedString
    }

    func updateExperiencePoints(add value: Int) {
        guard let expText = expLabel.attributedText?.string else { return }

        // Extract current experience and level
        let currentExp = Int(expText.components(separatedBy: " ")[1].split(separator: "/")[0]) ?? 0
        let currentLevel = Int(userLevelLabel.text ?? "1") ?? 1
        var newExp = currentExp + value

        // Update the attributed text for experience points
        let updatedExpString = NSMutableAttributedString()
        updatedExpString.append(NSAttributedString(string: "EXP ", attributes: [.font: UIFont.montserratMedium(size: 10), .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)]))
        updatedExpString.append(NSAttributedString(string: "\(newExp)", attributes: [.font: UIFont.montserratMedium(size: 10), .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)]))
        updatedExpString.append(NSAttributedString(string: "/20", attributes: [.font: UIFont.montserratMedium(size: 10), .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)]))

        expLabel.attributedText = updatedExpString
    }


    func configure(with userData: UserDataResponse) {
        nameLabel.text = userData.username
        userLevelLabel.text = "\(userData.level)"
        updateExperiencePoints(add: userData.experience)
        pointView.pointLabel.text = "\(userData.points)"
        if let imageUrl = URL(string: userData.image) {
            workoutImage.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(named: "avatar"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            workoutImage.image = UIImage(named: "avatar")
        }
    }
}
