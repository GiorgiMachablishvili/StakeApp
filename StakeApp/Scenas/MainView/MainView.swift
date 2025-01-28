//
//  MainView.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit
import Alamofire

class MainView: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(hexString: "#17191D")
        return view
    }()

    var exposedCollectionView: UICollectionView {
        return collectionView
    }

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

    }

    private func setupConstraint() {
        collectionView.snp.remakeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    func setupHierarchy() {
        collectionView.register(TopViewCell.self, forCellWithReuseIdentifier: String(describing: TopViewCell.self))
        collectionView.register(DailyBonusViewCell.self, forCellWithReuseIdentifier: String(describing: DailyBonusViewCell.self))
        collectionView.register(GamesViewCell.self, forCellWithReuseIdentifier: String(describing: GamesViewCell.self))
        collectionView.register(LeaderBoardViewCell.self, forCellWithReuseIdentifier: String(describing: LeaderBoardViewCell.self))
    }

    func configureCompositionLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            switch sectionIndex {
            case 0:
                return self?.topViewLayout()
            case 1:
                return self?.dailyBonusView()
            case 2:
                return self?.GameView()
            case 3:
                return self?.LeaderBoardView()
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
            top: -60 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func dailyBonusView() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(161 * Constraint.yCoeff))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(161 * Constraint.yCoeff)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 16 * Constraint.yCoeff,
            leading: 16 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 16 * Constraint.xCoeff
        )
        return section
    }

    func GameView() -> NSCollectionLayoutSection {
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
            top: 32 * Constraint.yCoeff,
            leading: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 0 * Constraint.xCoeff
        )
        return section
    }

    func LeaderBoardView() -> NSCollectionLayoutSection {
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
            top: 32 * Constraint.yCoeff,
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

}

extension MainView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
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
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: TopViewCell.self),
                for: indexPath) as? TopViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: DailyBonusViewCell.self),
                for: indexPath) as? DailyBonusViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: GamesViewCell.self),
                for: indexPath) as? GamesViewCell else {
                return UICollectionViewCell()
            }
            cell.onMinerGameButtonTapped = { [weak self] in
                guard let self = self else { return }
                let gamePreviewView = GamePreviewView()
                gamePreviewView.configureForMinerGame()
                gamePreviewView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(gamePreviewView, animated: true)
            }

            cell.onPandaGameButtonTapped = { [weak self] in
                guard let self = self else { return }
                let gamePreviewView = GamePreviewView()
                gamePreviewView.configureForPandaGame()
                gamePreviewView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(gamePreviewView, animated: true)
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: LeaderBoardViewCell.self),
                for: indexPath) as? LeaderBoardViewCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    private func navigateToGamePreviewView() {
        let gamePreviewView = GamePreviewView()

        gamePreviewView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gamePreviewView, animated: true)
    }
}
