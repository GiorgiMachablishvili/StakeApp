//
//  ProfileView.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit
import Alamofire

class ProfileView: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(hexString: "#17191D")
        return view
    }()

    private lazy var backgroundProfileView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()

    private lazy var profileView: EditProfileView = {
        let view = EditProfileView()
        view.makeRoundCorners(20)
        view.backgroundColor = .pointViewColor
        view.isHidden = true
        view.didPressCancelButton = { [weak self] in
            self?.hideView()
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainViewsBackViewBlack

        setup()
        setupConstraint()
        setupHierarchy()
        configureCompositionLayout()
    }

    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(backgroundProfileView)
        backgroundProfileView.addSubview(profileView)
    }

    private func setupConstraint() {
        collectionView.snp.remakeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        backgroundProfileView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(478)
        }
    }

    func setupHierarchy() {
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: String(describing: TopCell.self))
        collectionView.register(EditProfileCell.self, forCellWithReuseIdentifier: String(describing: EditProfileCell.self))
        collectionView.register(StaticCell.self, forCellWithReuseIdentifier: String(describing: StaticCell.self))
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: String(describing: SettingCell.self))
        collectionView.register(LeaderBoardCell.self, forCellWithReuseIdentifier: String(describing: LeaderBoardCell.self))
    }

    func configureCompositionLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            switch sectionIndex {
            case 0:
                return self?.topViewLayout()
            case 1:
                return self?.editProfileView()
            case 2:
                return self?.staticView()
            case 3:
                return self?.settingView()
            case 4:
                return self?.leaderBoardLayout()
            default:
                return self?.defaultLayout()
            }
        }
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }

    func topViewLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(112 * Constraint.yCoeff))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(112 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: -80 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func editProfileView() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(195 * Constraint.yCoeff))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(195 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 22 * Constraint.yCoeff,
            leading: 112 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 112 * Constraint.xCoeff
        )
        return section
    }

    func staticView() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(108 * Constraint.yCoeff))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(108 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 24 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func settingView() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(387 * Constraint.yCoeff))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(387 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 24 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func leaderBoardLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(365 * Constraint.yCoeff))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(365 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 24 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func defaultLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .absolute(200 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    @objc private func hideView() {
        backgroundProfileView.isHidden = true
        profileView.isHidden = true
    }
}

extension ProfileView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: TopCell.self),
                for: indexPath) as? TopCell else {
                return UICollectionViewCell()
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: EditProfileCell.self),
                for: indexPath) as? EditProfileCell else {
                return UICollectionViewCell()
            }
            cell.didPressEditProfileButton = { [weak self] in
                guard let self = self else { return }
                let gamePreviewView = GamePreviewView()
                backgroundProfileView.isHidden = false
                profileView.isHidden = false
                gamePreviewView.hidesBottomBarWhenPushed = true
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: StaticCell.self),
                for: indexPath) as? StaticCell else {
                return UICollectionViewCell()
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SettingCell.self),
                for: indexPath) as? SettingCell else {
                return UICollectionViewCell()
            }
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: LeaderBoardCell.self),
                for: indexPath) as? LeaderBoardCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
