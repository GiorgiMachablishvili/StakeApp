//
//  GamePreviewView.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class GamePreviewView: UIViewController {
    lazy var goldenBallImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "goldenBall")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var minerImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "minerWorker")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var pandaImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "pandaImage")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var pandaGameDescriptionImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "bambooImage")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var goldView: GoldsImageView = {
        let view = GoldsImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var minerGameView: MinerView = {
        let view = MinerView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.onStartButton = { [weak self] in
            self?.goMainerGameView()
        }
        view.onCancelButtonTapped = { [weak self] in
            self?.goBackView()
        }
        return view
    }()

    lazy var pandaGameView: PandasView = {
        let view = PandasView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.onCancelButtonTapped = { [weak self] in
            self?.goBackView()
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackColor
        setup()
        setupConstraints()
    }

    private func setup() {
        view.addSubview(goldenBallImage)
        view.addSubview(minerImage)
        view.addSubview(pandaImage)
        view.addSubview(pandaGameDescriptionImage)
        view.addSubview(goldView)
        view.addSubview(minerGameView)
        view.addSubview(pandaGameView)
    }

    private func setupConstraints() {
        goldenBallImage.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.height.width.equalTo(178)
        }

        minerImage.snp.remakeConstraints { make in
            make.top.equalTo(minerGameView.snp.top).offset(-306)
            make.leading.equalTo(view.snp.leading).offset(195)
            make.height.equalTo(373)
            make.width.equalTo(192)
        }

        goldView.snp.remakeConstraints { make in
            make.top.equalTo(minerGameView.snp.top).offset(-82)
            make.leading.equalTo(view.snp.leading).offset(-5)
            make.height.equalTo(97)
            make.width.equalTo(163)
        }

        pandaImage.snp.remakeConstraints { make in
            make.top.equalTo(pandaGameView.snp.top).offset(-306)
            make.leading.equalTo(view.snp.leading).offset(195)
            make.height.equalTo(373)
            make.width.equalTo(215)
        }

        pandaGameDescriptionImage.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(101)
            make.trailing.equalTo(pandaImage.snp.leading).offset(120)
            make.height.equalTo(196)
            make.height.equalTo(210)
        }

        minerGameView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(492)
        }

        pandaGameView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(583)
        }
    }

    func goMainerGameView() {
        let minerGameVC = MinerGameController()
        navigationController?.pushViewController(minerGameVC, animated: true)
    }

    func configureForMinerGame() {
        goldenBallImage.isHidden = false
        goldView.isHidden = false
        minerImage.isHidden = false
        minerGameView.isHidden = false
    }

    func configureForPandaGame() {
        pandaGameDescriptionImage.isHidden = false
        pandaImage.isHidden = false
        pandaGameView.isHidden = false
    }

    @objc private func goBackView() {
        navigationController?.popViewController(animated: true)
    }
}
