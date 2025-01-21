//
//  GameBoxCell.swift
//  StakeApp
//
//  Created by Gio's Mac on 20.01.25.
//

import UIKit
import SnapKit

class GameBoxCell: UICollectionViewCell {

    var onImageRevealed: (() -> Void)?

    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()


    lazy var coverView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.addSubview(questionMarkImageView)
        return view
    }()

    private lazy var questionMarkImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "mysteryBox")
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        setupConstraint()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(revealImage))
        coverView.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(coverView)
    }

    private func setupConstraint() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        questionMarkImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName)
        coverView.isHidden = false
    }

    @objc func revealImage() {
        coverView.isHidden = true
        onImageRevealed?()
    }
}
