//
//  EditProfileCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class EditProfileCell: UICollectionViewCell {

    var didPressEditProfileButton: (() -> Void)?

    private lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(50)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        //        view.isUserInteractionEnabled = true
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
        return view
    }()

    private lazy var editProfileButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.setTitle("Edit Profile", for: .normal)
        view.setTitleColor(UIColor.whiteColor, for: .normal)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(pressEditProfileButton), for: .touchUpInside)
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
        addSubview(workoutImage)
        addSubview(nameLabel)
        addSubview(expLabel)
        addSubview(editProfileButton)
    }

    private func setupConstraints() {
        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(2 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.width.equalTo(100 * Constraint.yCoeff)
        }

        nameLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(workoutImage.snp.centerX)
            make.top.equalTo(workoutImage.snp.bottom).offset(8 * Constraint.yCoeff)
            make.height.equalTo(20 * Constraint.yCoeff)
        }

        expLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(workoutImage.snp.centerX)
            make.top.equalTo(nameLabel.snp.bottom).offset(8 * Constraint.yCoeff)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        editProfileButton.snp.remakeConstraints { make in
            make.centerX.equalTo(workoutImage.snp.centerX)
            make.top.equalTo(expLabel.snp.bottom).offset(8 * Constraint.yCoeff)
            make.height.equalTo(39 * Constraint.yCoeff)
            make.width.equalTo(163 * Constraint.xCoeff)
        }
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

    @objc private func pressEditProfileButton() {
        didPressEditProfileButton?()
    }
}
