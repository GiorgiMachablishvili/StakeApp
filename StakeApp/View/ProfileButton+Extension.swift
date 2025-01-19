//
//  ProfileButton+Extension.swift
//  StakeApp
//
//  Created by Gio's Mac on 18.01.25.
//

import UIKit
import SnapKit

extension UIButton {
    /// Configure a button with a left image, title, and right image.
    func configureButton(leftImage: UIImage?, title: String, rightImage: UIImage?, spacing: CGFloat = 8 * Constraint.xCoeff) {
        // Remove existing subviews
        self.subviews.forEach { $0.removeFromSuperview() }

        // Left Image View
        let leftImageView = UIImageView(image: leftImage)
        leftImageView.contentMode = .scaleAspectFit

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = self.titleLabel?.font
        titleLabel.textColor = self.titleColor(for: .normal)
        titleLabel.textAlignment = .center

        // Right Image View
        let rightImageView = UIImageView(image: rightImage)
        rightImageView.contentMode = .scaleAspectFit

        // Add stack view to the button
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(rightImageView)

        // Enable Auto Layout for the stack view
        leftImageView.snp.remakeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(snp.leading).offset(16 * Constraint.xCoeff)
            make.height.width.equalTo(32 * Constraint.yCoeff)
        }

        titleLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(leftImageView.snp.trailing).offset(12 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        rightImageView.snp.remakeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-24 * Constraint.xCoeff)
            make.height.equalTo(15.5 * Constraint.yCoeff)
            make.width.equalTo(7.5 * Constraint.xCoeff)
        }
    }
}

