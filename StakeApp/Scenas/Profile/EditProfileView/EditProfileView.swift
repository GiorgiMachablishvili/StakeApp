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
    var didUpdateImage: ((UIImage) -> Void)?

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

    lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(50)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserImageView))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    private lazy var editImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
//        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(16)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "editImage")
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
        addSubview(editImage)
        addSubview(nicknameBackgroundView)
        nicknameBackgroundView.addSubview(nicknameTextField)
        addSubview(birthdayBackgroundView)
        birthdayBackgroundView.addSubview(birthdayTextField)
        addSubview(saveButton)
        addSubview(cancelButton)
    }

    private func setupConstraints() {
        viewTitle.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(20 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(20 * Constraint.xCoeff)
            make.height.equalTo(24 * Constraint.yCoeff)
        }

        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(viewTitle.snp.bottom).offset(20 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.width.equalTo(100 * Constraint.yCoeff)
        }

        editImage.snp.remakeConstraints { make in
            make.trailing.equalTo(workoutImage.snp.trailing).offset(4 * Constraint.xCoeff)
            make.bottom.equalTo(workoutImage.snp.bottom).offset(4 * Constraint.yCoeff)
            make.height.width.equalTo(32 * Constraint.yCoeff)
        }

        nicknameBackgroundView.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.bottom).offset(20 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(55 * Constraint.yCoeff)
        }

        nicknameTextField.snp.remakeConstraints { make in
            make.centerY.equalTo(nicknameBackgroundView.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(40 * Constraint.yCoeff)
        }

        birthdayBackgroundView.snp.remakeConstraints { make in
            make.top.equalTo(nicknameBackgroundView.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(55 * Constraint.yCoeff)
        }

        birthdayTextField.snp.remakeConstraints { make in
            make.centerY.equalTo(birthdayBackgroundView.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(12 * Constraint.xCoeff)
            make.height.equalTo(40 * Constraint.yCoeff)
        }

        saveButton.snp.remakeConstraints { make in
            make.top.equalTo(birthdayBackgroundView.snp.bottom).offset(20 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }

        cancelButton.snp.remakeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }
    }


    @objc private func didTapUserImageView() {
        print("did press image")
           guard let parentViewController = self.findViewController() else { return }
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = parentViewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
           imagePicker.sourceType = .photoLibrary
           imagePicker.allowsEditing = true
           parentViewController.present(imagePicker, animated: true, completion: nil)
       }

    @objc private func pressSaveButton() {

    }

    @objc private func pressCancelButton() {
        didPressCancelButton?()
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
}
