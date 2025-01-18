//
//  GameTopView.swift
//  StakeApp
//
//  Created by Gio's Mac on 18.01.25.
//

import UIKit
import SnapKit

class GameTopView: UIView {

    private lazy var startPauseButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "pauseButton"), for: .normal)
        view.makeRoundCorners(20)
//        view.addTarget(self, action: #selector(clickSkipButton), for: .touchUpInside)
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
        addSubview(startPauseButton)
        addSubview(pointView)
    }

    private func setupConstraints() {
        startPauseButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-16)
            make.leading.equalTo(snp.leading).offset(16)
            make.width.height.equalTo(40)
        }

        pointView.snp.remakeConstraints { make in
            make.centerY.equalTo(startPauseButton.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(85)
        }
    }

}
