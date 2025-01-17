//
//  GamesViewCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit
import SnapKit

class GamesViewCell: UICollectionViewCell {

    var onMinerGameButtonTapped: (() -> Void)?
    var onPandaGameButtonTapped: (() -> Void)?

    private lazy var backgroundGameView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }()

    private lazy var gameConsolerImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "gameLine")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var minerGameButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "minersGame"), for: .normal)
        view.backgroundColor = UIColor.clear
        view.makeRoundCorners(16)
        view.imageView?.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(clickMinerGameButton), for: .touchUpInside)
        return view
    }()

    private lazy var pandaGameButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "pandasGame"), for: .normal)
        view.backgroundColor = UIColor.clear
        view.makeRoundCorners(16)
        view.imageView?.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(clickPandaGameButton), for: .touchUpInside)
        return view
    }()

    private lazy var newGameButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "newGame"), for: .normal)
        view.backgroundColor = UIColor.clear
        view.imageView?.contentMode = .scaleToFill
        view.clipsToBounds = true
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
        addSubview(backgroundGameView)
        backgroundGameView.addSubview(gameConsolerImage)
        backgroundGameView.addSubview(minerGameButton)
        backgroundGameView.addSubview(pandaGameButton)
        backgroundGameView.addSubview(newGameButton)
    }

    private func setupConstraints() {
        backgroundGameView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gameConsolerImage.snp.remakeConstraints { make in
            make.top.equalTo(backgroundGameView.snp.top).offset(2)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }

        minerGameButton.snp.remakeConstraints { make in
            make.top.equalTo(gameConsolerImage.snp.bottom).offset(16)
            make.leading.equalTo(backgroundGameView.snp.leading).offset(16)
            make.height.equalTo(207)
            make.width.equalTo(171)
        }

        pandaGameButton.snp.remakeConstraints { make in
            make.top.equalTo(gameConsolerImage.snp.bottom).offset(16)
            make.trailing.equalTo(backgroundGameView.snp.trailing).offset(-16)
            make.height.equalTo(207)
            make.width.equalTo(171)
        }

        newGameButton.snp.remakeConstraints { make in
            make.top.equalTo(minerGameButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(111)
        }
    }

    @objc private func clickMinerGameButton() {
        onMinerGameButtonTapped?()
    }

    @objc private func clickPandaGameButton() {
        onPandaGameButtonTapped?()
    }

}
