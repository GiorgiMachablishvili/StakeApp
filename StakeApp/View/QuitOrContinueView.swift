//
//  QuitOrContinueView.swift
//  StakeApp
//
//  Created by Gio's Mac on 21.01.25.
//

import UIKit
import SnapKit

class QuitOrContinueView: UIView {

    var pressContinueButton: (() -> Void)?
    var pressQuitButton: (() -> Void)?

    private lazy var leaveOrNotLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Are you sure you want to leave the game?"
        view.textColor = UIColor.whiteColor
        view.font = UIFont.montserratBlack(size: 20)
        view.textAlignment = .left
        view.numberOfLines = 2
        return view
    }()

    private lazy var leaveOrNotInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "You will be scored a defeat and lose experience points "
        view.textColor = UIColor.grayLabel
        view.font = UIFont.montserratBold(size: 12)
        view.textAlignment = .left
        view.numberOfLines = 2
        return view
    }()

    private lazy var continuePlayingButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Continue playing", for: .normal)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.makeRoundCorners(12)
        view.addTarget(self, action: #selector(clickContinuePlayingButton), for: .touchUpInside)
        return view
    }()

    private lazy var quitTheGameButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Quit the game ", for: .normal)
        view.backgroundColor = UIColor.clear
        view.makeRoundCorners(12)
        view.addTarget(self, action: #selector(clickQuitTheGameButton), for: .touchUpInside)
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
        addSubview(leaveOrNotLabel)
        addSubview(leaveOrNotInfoLabel)
        addSubview(continuePlayingButton)
        addSubview(quitTheGameButton)
    }

    private func setupConstraints() {
        leaveOrNotLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(20 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(48 * Constraint.yCoeff)
        }

        leaveOrNotInfoLabel.snp.remakeConstraints { make in
            make.top.equalTo(leaveOrNotLabel.snp.bottom).offset(12 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(30 * Constraint.yCoeff)
        }

        continuePlayingButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-104 * Constraint.yCoeff)
            make.leading.trailing.equalTo(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }

        quitTheGameButton.snp.remakeConstraints { make in
            make.top.equalTo(continuePlayingButton.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalTo(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }
    }

    @objc private func clickContinuePlayingButton() {
        pressContinueButton?()
    }

    @objc private func clickQuitTheGameButton() {
        pressQuitButton?()
    }
}

