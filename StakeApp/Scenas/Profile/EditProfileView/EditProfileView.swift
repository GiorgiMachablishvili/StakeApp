//
//  EditProfileView.swift
//  StakeApp
//
//  Created by Gio's Mac on 18.01.25.
//

import UIKit
import SnapKit

class EditProfileView: UIView {

    var didPressCancelButton: (() -> Void)?

    private lazy var backgroundTopView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var viewTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Edit profile"
        view.font = UIFont.montserratBold(size: 20)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

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

    private lazy var nicknameBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(20)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var nicknameTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.placeholder = "Your Nickname "
        view.font = UIFont.montserratBold(size: 20)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        view.backgroundColor = .clear
        return view
    }()

    private lazy var birthdayBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(20)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var birthdayTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.placeholder = "Your birthday"
        view.font = UIFont.montserratBold(size: 20)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        view.backgroundColor = .clear
        return view
    }()

    private lazy var saveButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.setTitle("Save", for: .normal)
        view.setTitleColor(UIColor.whiteColor, for: .normal)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(pressSaveButton), for: .touchUpInside)
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.clear
        view.setTitle("cancel", for: .normal)
        view.setTitleColor(UIColor.whiteColor, for: .normal)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(pressCancelButton), for: .touchUpInside)
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
        addSubview(viewTitle)
        addSubview(workoutImage)
        addSubview(nicknameBackgroundView)
        nicknameBackgroundView.addSubview(nicknameTextField)
        addSubview(birthdayBackgroundView)
        birthdayBackgroundView.addSubview(birthdayTextField)
        addSubview(saveButton)
        addSubview(cancelButton)
    }

    private func setupConstraints() {
        viewTitle.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(20)
            make.leading.equalTo(snp.leading).offset(20)
            make.height.equalTo(24)
        }

        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(viewTitle.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
            make.height.width.equalTo(100)
        }

        nicknameBackgroundView.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }

        nicknameTextField.snp.remakeConstraints { make in
            make.centerY.equalTo(nicknameBackgroundView.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }

        birthdayBackgroundView.snp.remakeConstraints { make in
            make.top.equalTo(nicknameBackgroundView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }

        birthdayTextField.snp.remakeConstraints { make in
            make.centerY.equalTo(birthdayBackgroundView.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }

        saveButton.snp.remakeConstraints { make in
            make.top.equalTo(birthdayBackgroundView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }

        cancelButton.snp.remakeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
    }

    @objc private func pressSaveButton() {

    }

    @objc private func pressCancelButton() {
        didPressCancelButton?()
    }
}
