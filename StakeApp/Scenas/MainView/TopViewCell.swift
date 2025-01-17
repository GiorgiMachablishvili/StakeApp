//
//  TopViewCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit

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
        view.layer.cornerRadius = 24
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
        backgroundTopView.addSubview(nameLabel)
        backgroundTopView.addSubview(expLabel)
        backgroundTopView.addSubview(pointView)
    }

    private func setupConstraints() {
        backgroundTopView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(48)
            make.leading.equalTo(snp.leading).offset(16)
            make.height.width.equalTo(48)
        }

        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.top).offset(9)
            make.leading.equalTo(workoutImage.snp.trailing).offset(8)
            make.height.equalTo(16)
        }

        expLabel.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(workoutImage.snp.trailing).offset(8)
            make.height.equalTo(12)
        }

        pointView.snp.remakeConstraints { make in
            make.centerY.equalTo(workoutImage.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(85)
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

}
