//
//  SignInController.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit
import AuthenticationServices
import Alamofire
import ProgressHUD

class SignInController: UIViewController {
    private lazy var mainImageConsole: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "signinViewImage")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var signTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "SIGN IN"
        view.textColor = UIColor.whiteColor
        view.font = UIFont.montserratBold(size: 32)
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()

    private lazy var signInInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Sign in with your Apple account to transfer your account data and keep it safe."
        view.textColor = UIColor.grayLabel
        view.font = UIFont.montserratBold(size: 16)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()

    private lazy var signInWithAppleButton: UIButton = {
        let view = UIButton(frame: .zero)
            view.setTitle("Tie the account to Apple. ", for: .normal)
        view.setTitleColor(UIColor.titlesBlack, for: .normal)
        view.backgroundColor = UIColor.whiteColor
            view.makeRoundCorners(16)
        view.titleLabel?.font = UIFont.montserratBlack(size: 12)
        view.layer.borderColor = UIColor.whiteColor.cgColor
            view.layer.borderWidth = 1
            let image = UIImage(named: "apple")?.withRenderingMode(.alwaysOriginal)
            let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 24)).image { _ in
                image?.draw(in: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
            }
            view.setImage(resizedImage, for: .normal)
            view.imageView?.contentMode = .scaleAspectFit
            view.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            view.contentHorizontalAlignment = .center
            view.addTarget(self, action: #selector(clickSignInWithAppleButton), for: .touchUpInside)
            return view
    }()

    private lazy var skipButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Skip", for: .normal)
        view.backgroundColor = UIColor.whiteColor.withAlphaComponent(0.15)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(clickSkipButton), for: .touchUpInside)
        return view
    }()

    private lazy var termsButton: UIButton = {
        let view = UIButton(frame: .zero)
        let attributedTitle = NSAttributedString(
            string: "Terms of Use",
            attributes: [
                .font: UIFont.montserratRegular(size: 12),
                .foregroundColor: UIColor.whiteColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        view.setAttributedTitle(attributedTitle, for: .normal)
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(clickTermsButton), for: .touchUpInside)
        return view
    }()

    private lazy var privacyPolicyButton: UIButton = {
        let view = UIButton(frame: .zero)
        let attributedTitle = NSAttributedString(
            string: "Privacy Policy",
            attributes: [
                .font: UIFont.montserratRegular(size: 12),
                .foregroundColor: UIColor.whiteColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        view.setAttributedTitle(attributedTitle, for: .normal)
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(clickPrivacyPolicyButton), for: .touchUpInside)
        return view
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainViewsBackViewBlack

        setup()
        setupConstraints()
    }

    private func setup() {
        view.addSubview(mainImageConsole)
        view.addSubview(signTitle)
        view.addSubview(signInInfoLabel)
        view.addSubview(signInWithAppleButton)
        view.addSubview(skipButton)
        view.addSubview(termsButton)
        view.addSubview(privacyPolicyButton)
    }

    private func setupConstraints() {
        mainImageConsole.snp.remakeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(-20)
            make.leading.equalTo(view.snp.leading).offset(-20)
            make.trailing.equalTo(view.snp.trailing).offset(20)
            make.height.equalTo(380 * Constraint.yCoeff)
        }

        signTitle.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(368)
            make.leading.trailing.equalToSuperview().inset(32 * Constraint.xCoeff)
            make.height.equalTo(39 * Constraint.yCoeff)
        }

        signInInfoLabel.snp.remakeConstraints { make in
            make.top.equalTo(signTitle.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(32 * Constraint.xCoeff)
            make.height.equalTo(60 * Constraint.yCoeff)
        }

        signInWithAppleButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-150 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }

        skipButton.snp.remakeConstraints { make in
            make.top.equalTo(signInWithAppleButton.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }

        termsButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-32 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(20 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        privacyPolicyButton.snp.remakeConstraints { make in
            make.centerY.equalTo(termsButton.snp.centerY)
            make.trailing.equalTo(view.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

    }

    @objc private func clickTermsButton() {

    }

    @objc private func clickPrivacyPolicyButton() {

    }

    @objc private func clickSignInWithAppleButton() {

    }

    @objc private func clickSkipButton() {
        let mainViewTabBarController = MainViewControllerTab()
        navigationController?.pushViewController(mainViewTabBarController, animated: true)

    }
}


