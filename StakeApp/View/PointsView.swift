//
//  PointsView.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit

class PointsView: UIView {
    lazy var pointLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "100"
        view.textColor = UIColor.whiteColor
        view.font = UIFont.montserratBold(size: 14)
        view.textAlignment = .left
        return view
    }()

    private lazy var verticalLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .whiteColor
        return view
    }()

    private lazy var consoleImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "consollerImage")
        view.contentMode = .scaleAspectFit
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
        addSubview(pointLabel)
        addSubview(verticalLine)
        addSubview(consoleImage)
    }

    private func setupConstraints() {
        pointLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(11.5 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(12 * Constraint.xCoeff)
            make.width.equalTo(25 * Constraint.xCoeff)
            make.height.equalTo(17 * Constraint.yCoeff)
        }

        verticalLine.snp.remakeConstraints { make in
            make.centerY.equalTo(pointLabel.snp.centerY)
            make.trailing.equalTo(consoleImage.snp.leading).offset(-8 * Constraint.xCoeff)
            make.height.equalTo(16 * Constraint.yCoeff)
            make.width.equalTo(0.5 * Constraint.xCoeff)
        }

        consoleImage.snp.remakeConstraints { make in
            make.centerY.equalTo(pointLabel.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-8 * Constraint.xCoeff)
            make.height.width.equalTo(24 * Constraint.yCoeff)
        }
    }

    func incrementPoint(by value: Int) {
        if let currentPoints = Int(pointLabel.text ?? "0") {
            pointLabel.text = "\(currentPoints + value)"
        }
    }
}
