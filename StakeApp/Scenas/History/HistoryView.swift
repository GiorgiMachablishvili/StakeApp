//
//  HistoryView.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit

class HistoryView: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(hexString: "#17191D")
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

    }

    private func setupConstraint() {
        collectionView.snp.remakeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    func setupHierarchy() {
        collectionView.register(TopHistoryCell.self, forCellWithReuseIdentifier: String(describing: TopHistoryCell.self))
        collectionView.register(DailyGameCell.self, forCellWithReuseIdentifier: String(describing: DailyGameCell.self))
    }

    func configureCompositionLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            switch sectionIndex {
            case 0:
                return self?.topHistoryLayout()
            case 1:
                return self?.dailyGameView()
            default:
                return self?.defaultLayout()
            }
        }
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }

    func topHistoryLayout() -> NSCollectionLayoutSection {
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

    func dailyGameView() -> NSCollectionLayoutSection {
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
            top: 14 * Constraint.yCoeff,
            leading: 16 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            trailing: 16 * Constraint.xCoeff
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

extension HistoryView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: TopHistoryCell.self),
                for: indexPath) as? TopHistoryCell else {
                return UICollectionViewCell()
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: DailyGameCell.self),
                for: indexPath) as? DailyGameCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
