//
//  PandasView.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class PandasView: UIView {

    var onStartGameButton: (() -> Void)?
    var onCancelButtonTapped: (() -> Void)?

    private lazy var backgroundMinerView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(20)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var gameTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Pandas and baboons"
        view.font = UIFont.montserratBold(size: 20)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    private lazy var gameInfo: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Сompete with your opponent by opening cells on the field. Your task is to find more bamboos than your opponent. Avoid traps and use power-ups for an advantage!"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.grayLabel
        view.textAlignment = .left
        view.numberOfLines = 4
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.setImage(UIImage(named: "closeButton"), for: .normal)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(didPressCancelButton), for: .touchUpInside)
        return view
    }()

    private lazy var bonusesLabel: BonusesStringAttributed = {
        let view = BonusesStringAttributed()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelText = "BONUSES"
        return view
    }()

    private lazy var x2View: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = .whiteColor.withAlphaComponent(0.25)
        view.configureView(
            image: UIImage(named: "x2"),
            title: "X2",
            viewInfo: "Double your loot if you find a bamboo."
        )
        return view
    }()

    private lazy var trapView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = .white.withAlphaComponent(0.25)
        view.configureView(
            image: UIImage(named: "trap"),
            title: "Trap",
            viewInfo: "Set it on a cell. If your opponent gets caught, they will miss a turn."
        )
        // Apply gradient
        view.applyGradient(colors: [UIColor.blue, UIColor.red])
        return view
    }()

    private lazy var mixView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = .whiteColor.withAlphaComponent(0.25)
        view.configureView(
            image: UIImage(named: "mix"),
            title: "Mix",
            viewInfo: "Mixes all closed cells, including traps and bonuses."
        )
        return view
    }()

    private lazy var scannerView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = .whiteColor.withAlphaComponent(0.25)
        view.configureView(
            image: UIImage(named: "scanner"),
            title: "Scanner",
            viewInfo: "Shows you what is hidden in the selected cell."
        )
        return view
    }()

    private lazy var startGameButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.setTitle("Start the game", for: .normal)
        view.setTitleColor(UIColor.whiteColor, for: .normal)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(pressStartGameButton), for: .touchUpInside)
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
        addSubview(backgroundMinerView)
        backgroundMinerView.addSubview(gameTitle)
        backgroundMinerView.addSubview(gameInfo)
        backgroundMinerView.addSubview(cancelButton)
        backgroundMinerView.addSubview(bonusesLabel)
        backgroundMinerView.addSubview(x2View)
        backgroundMinerView.addSubview(trapView)
        backgroundMinerView.addSubview(mixView)
        backgroundMinerView.addSubview(scannerView)
        backgroundMinerView.addSubview(startGameButton)
    }

    private func setupConstraints() {
        backgroundMinerView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        gameTitle.snp.remakeConstraints { make in
            make.top.equalTo(backgroundMinerView.snp.top).offset(20 * Constraint.yCoeff)
            make.leading.equalTo(backgroundMinerView.snp.leading).offset(20 * Constraint.xCoeff)
            make.height.equalTo(24 * Constraint.yCoeff)
        }

        gameInfo.snp.remakeConstraints { make in
            make.top.equalTo(gameTitle.snp.bottom).offset(16 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
        }

        cancelButton.snp.remakeConstraints { make in
            make.top.equalTo(backgroundMinerView.snp.top).offset(20 * Constraint.yCoeff)
            make.trailing.equalTo(backgroundMinerView.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.height.width.equalTo(24 * Constraint.yCoeff)
        }

        bonusesLabel.snp.remakeConstraints { make in
            make.top.equalTo(gameInfo.snp.bottom).offset(20 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        x2View.snp.remakeConstraints { make in
            make.top.equalTo(bonusesLabel.snp.bottom).offset(16 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(68 * Constraint.yCoeff)
        }

        trapView.snp.remakeConstraints { make in
            make.top.equalTo(x2View.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(68 * Constraint.yCoeff)
        }

        mixView.snp.remakeConstraints { make in
            make.top.equalTo(trapView.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(68 * Constraint.yCoeff)
        }

        scannerView.snp.remakeConstraints { make in
            make.top.equalTo(mixView.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(68 * Constraint.yCoeff)
        }

        startGameButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-44 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }
    }

    @objc private func pressStartGameButton() {
        onStartGameButton?()
    }

    @objc private func didPressCancelButton() {
        onCancelButtonTapped?()
    }
}


extension UIView {
    func applyGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
