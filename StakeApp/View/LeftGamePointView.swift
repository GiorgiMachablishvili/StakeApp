//
//  LeftGamePointView.swift
//  StakeApp
//
//  Created by Gio's Mac on 18.01.25.
//

import UIKit
import SnapKit

class LeftGamePointView: UIView {

    private lazy var backgroundGamePointView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(20)
        view.backgroundColor = UIColor.backgroundColorGamePointView.withAlphaComponent(0.2)
        return view
    }()

    lazy var gameImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "bamboImage")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var pointLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "60"
        view.textColor = UIColor.whiteColor
        view.font = UIFont.montserratBold(size: 14)
        view.textAlignment = .left
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
        addSubview(backgroundGamePointView)
        backgroundGamePointView.addSubview(gameImage)
        backgroundGamePointView.addSubview(pointLabel)

    }

    private func setupConstraints() {
        backgroundGamePointView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        gameImage.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundGamePointView.snp.centerY)
            make.leading.equalTo(backgroundGamePointView.snp.leading).offset(4)
            make.height.width.equalTo(28)
        }

        pointLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundGamePointView.snp.centerY)
            make.leading.equalTo(gameImage.snp.trailing).offset(2)
//            make.width.equalTo(25)
            make.height.equalTo(17)
        }
    }
}
