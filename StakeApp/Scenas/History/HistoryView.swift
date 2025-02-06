//
//  HistoryView.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit

class HistoryView: UIViewController {

    private var userData: UserDataResponse?
    private var userHistoryInfo: UserGameHistory?
    private var userHistoryList: [UserGameHistory] = []

    private lazy var topView: TopViewCell = {
        let view = TopViewCell()
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(hexString: "#17191D")
        return view
    }()

    private lazy var emptyLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Empty"
        view.font = UIFont.montserratBlack(size: 20)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()

    private lazy var emptyLabelInfo: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "You haven't played any games yet"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.grayLabel
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mainViewsBackViewBlack

        setup()
        setupConstraint()
        setupHierarchy()
        configureCompositionLayout()

        hideOrNotEmptyLabel()
//        fetchUserData()
        fetchUserGameHistory()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
    }

    private func setup() {
        view.addSubview(topView)
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        view.addSubview(emptyLabelInfo)

    }

    private func setupConstraint() {
        topView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        emptyLabel.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(370 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(24 * Constraint.yCoeff)
        }

        emptyLabelInfo.snp.remakeConstraints { make in
            make.top.equalTo(emptyLabel.snp.bottom).offset(16 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(15 * Constraint.yCoeff)
        }
    }

    func setupHierarchy() {
//        collectionView.register(TopHistoryCell.self, forCellWithReuseIdentifier: String(describing: TopHistoryCell.self))
        collectionView.register(DailyGameCell.self, forCellWithReuseIdentifier: String(describing: DailyGameCell.self))
    }

    func hideOrNotEmptyLabel() {
        if userHistoryList.count > 0 {
            emptyLabel.isHidden = true
            emptyLabelInfo.isHidden = true
        } else {
            emptyLabel.isHidden = false
            emptyLabelInfo.isHidden = false
        }
    }

    private func fetchUserData() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("userId not found or not an Int")
            return
        }

        let url = String.userDataResponse(userId: userId)
        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<UserDataResponse>) in
            switch result {
            case .success(let userData):
                self.userData = userData
                DispatchQueue.main.async {
                    self.topView.configure(with: userData)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
            }
        }
    }

    private func fetchUserGameHistory() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("userId not found or not an Int")
            return
        }

        let url = String.userGameHistoryGet(userId: userId)
        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<[UserGameHistory]>) in
            switch result {
            case .success(let userHistoryList):
                self.userHistoryList = userHistoryList
                DispatchQueue.main.async {
                    self.hideOrNotEmptyLabel()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
            }
        }
    }

    func configureCompositionLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            switch sectionIndex {
//            case 0:
//                return self?.topHistoryLayout()
            case 0:
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
            top: -60 * Constraint.yCoeff,
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
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
//        case 0:
//            return 1
        case 0:
            return userHistoryList.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
//        case 0:
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: String(describing: TopHistoryCell.self),
//                for: indexPath) as? TopHistoryCell else {
//                return UICollectionViewCell()
//            }
//            if let userData = userData {
//                cell.configure(with: userData)
//            }
//            return cell
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: DailyGameCell.self),
                for: indexPath) as? DailyGameCell else {
                return UICollectionViewCell()
            }
            let historyEntry = userHistoryList[indexPath.item]
            cell.configure(with: historyEntry)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
