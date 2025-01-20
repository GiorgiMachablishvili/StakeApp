//
//  FindingAnOpponentsController.swift
//  StakeApp
//
//  Created by Gio's Mac on 20.01.25.
//

import UIKit
import SnapKit

class FindingAnOpponentsController: UIViewController {

    private lazy var findingTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Finding an opponent"
        view.font = UIFont.montserratBlack(size: 20)
        view.textAlignment = .center
        view.textColor = .whiteColor
        return view
    }()

    private lazy var findingInfoTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Looking for an opponent for you, this will take some time"
        view.font = UIFont.montserratBold(size: 12)
        view.textAlignment = .center
        view.textColor = .grayLabel
        view.numberOfLines = 2
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Cancel", for: .normal)
        view.backgroundColor = UIColor.whiteColor.withAlphaComponent(0.15)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        return view
    }()

    private var dotTimer: Timer?
    private var dotCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainViewsBackViewBlack

        setup()
        setupConstraints()
        startDotAnimation()
    }

    private func setup() {
        view.addSubview(findingTitle)
        view.addSubview(findingInfoTitle)
        view.addSubview(cancelButton)
    }

    private func setupConstraints() {
        findingTitle.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(387 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(57 * Constraint.xCoeff)
            make.height.equalTo(24 * Constraint.yCoeff)
        }

        findingInfoTitle.snp.remakeConstraints { make in
            make.top.equalTo(findingTitle.snp.bottom).offset(16 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(57 * Constraint.xCoeff)
            make.height.equalTo(30 * Constraint.yCoeff)
        }

        cancelButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-78 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }
    }

    private func startDotAnimation() {
        dotTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateDots), userInfo: nil, repeats: true)
    }

    private func stopDotAnimation() {
        dotTimer?.invalidate()
        dotTimer = nil
    }

    @objc private func updateDots() {
        dotCount = (dotCount + 1) % 4 // Cycle through 0, 1, 2, 3
        let dots = String(repeating: ".", count: dotCount)
        findingTitle.text = "Finding an opponent\(dots)"
    }

    @objc private func clickCancelButton() {
        stopDotAnimation()
        navigationController?.popViewController(animated: true)
    }
}
