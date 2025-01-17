//
//  SettingCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class SettingCell: UICollectionViewCell {
    private lazy var bonusesLabel: BonusesStringAttributed = {
        let view = BonusesStringAttributed()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelText = "SETTING"
        return view
    }()

    private lazy var termOfUse: UIButton = {
        let view = UIButton(frame: .zero)
        view.makeRoundCorners(20)
        view.configureButton(
            leftImage: UIImage(named: "termOfUs"),
            title: "Term of Use",
            rightImage: UIImage(named: "rightErrow")
        )
        view.addTarget(self, action: #selector(pressTermOfUse), for: .touchUpInside)
        return view
    }()

    private lazy var privacyAndPolicy: UIButton = {
        let view = UIButton(frame: .zero)
        view.makeRoundCorners(20)
        view.configureButton(
            leftImage: UIImage(named: "privacyAndPolicy"),
            title: "Privacy Policy",
            rightImage: UIImage(named: "rightErrow")
        )
        view.addTarget(self, action: #selector(pressPrivacyAndPolicy), for: .touchUpInside)
        return view
    }()

    private lazy var rateUs: UIButton = {
        let view = UIButton(frame: .zero)
        view.makeRoundCorners(20)
        view.configureButton(
            leftImage: UIImage(named: "rateUs"),
            title: "Rate us",
            rightImage: UIImage(named: "rightErrow")
        )
        view.addTarget(self, action: #selector(pressRateUs), for: .touchUpInside)
        return view
    }()

    private lazy var support: UIButton = {
        let view = UIButton(frame: .zero)
        view.makeRoundCorners(20)
        view.configureButton(
            leftImage: UIImage(named: "support"),
            title: "Support",
            rightImage: UIImage(named: "rightErrow")
        )
        view.addTarget(self, action: #selector(pressSupport), for: .touchUpInside)
        return view
    }()

    private lazy var signInWithAppleButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Tie the account to Apple. ", for: .normal)
        view.setTitleColor(UIColor.titlesBlack, for: .normal)
        view.backgroundColor = UIColor.whiteColor
        view.makeRoundCorners(16)
        view.titleLabel?.font = UIFont.montserratBold(size: 12)
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


    private lazy var deleteButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Delete Account", for: .normal)
        view.setTitleColor(UIColor(hexString: "#DF141E1A"), for: .normal)
        view.backgroundColor = UIColor(hexString: "#DF141E").withAlphaComponent(0.1)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(clickDeleteButton), for: .touchUpInside)
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
        addSubview(bonusesLabel)
        addSubview(termOfUse)
        addSubview(privacyAndPolicy)
        addSubview(rateUs)
        addSubview(support)
        addSubview(signInWithAppleButton)
        addSubview(deleteButton)
    }

    private func setupConstraints() {
        bonusesLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(2)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }

        termOfUse.snp.remakeConstraints { make in
            make.top.equalTo(bonusesLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }

        privacyAndPolicy.snp.remakeConstraints { make in
            make.top.equalTo(termOfUse.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }

        rateUs.snp.remakeConstraints { make in
            make.top.equalTo(privacyAndPolicy.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }

        support.snp.remakeConstraints { make in
            make.top.equalTo(rateUs.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }

        signInWithAppleButton.snp.remakeConstraints { make in
            make.top.equalTo(support.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }

        deleteButton.snp.remakeConstraints { make in
            make.top.equalTo(support.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
    }

    //TODO: add links
    @objc private func pressTermOfUse() {

    }

    @objc private func pressPrivacyAndPolicy() {

    }

    @objc private func pressRateUs() {

    }

    @objc private func pressSupport() {

    }

    //TODO: signin
    @objc private func clickSignInWithAppleButton() {

    }
    //TODO: delete
    @objc private func clickDeleteButton() {

    }


}
