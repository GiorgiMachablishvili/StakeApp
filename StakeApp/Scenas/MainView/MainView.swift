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

    private var userData: UserDataResponse?
    private var leaderboardUsers: [LeaderBoardStatic] = []
    private var bonusTimer: BonusTimer?

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

        fetchLeaderboardData()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
        fetchBonusTimer()
    }

    private func setup() {
        view.addSubview(topView)
        view.addSubview(collectionView)

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
    }

    func setupHierarchy() {
//        collectionView.register(TopViewCell.self, forCellWithReuseIdentifier: String(describing: TopViewCell.self))
        collectionView.register(DailyBonusViewCell.self, forCellWithReuseIdentifier: String(describing: DailyBonusViewCell.self))
        collectionView.register(GamesViewCell.self, forCellWithReuseIdentifier: String(describing: GamesViewCell.self))
        collectionView.register(LeaderBoardViewCell.self, forCellWithReuseIdentifier: String(describing: LeaderBoardViewCell.self))
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

    private func fetchLeaderboardData() {
        let url = String.leaderBoard()
        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<[LeaderBoardStatic]>) in
            switch result {
            case .success(let users):
                self.leaderboardUsers = users.sorted { $0.points > $1.points }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
            }
        }
    }

    private func fetchBonusTimer() {
        let url = String.bonusTimer()

        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<BonusTimer>) in
            switch result {
            case .success(let response):
                print("Raw next_bonus_time from backend: \(response.nextBonusTime)")

                let isoFormatter = ISO8601DateFormatter()
                isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

                if let date = isoFormatter.date(from: response.nextBonusTime) {
                    print("Parsed date: \(date)")
                    let nextBonusTimestamp = date.timeIntervalSince1970
                    DispatchQueue.main.async {
                        self.updateBonusTimer(with: nextBonusTimestamp)
                    }
                } else {
                    print("Error: Failed to parse next_bonus_time as a valid date")
                }
            case .failure(let error):
                print("Failed to fetch bonus timer: \(error.localizedDescription)")
            }
        }
    }

    private func postDailyBonus() {
        NetworkManager.shared.showProgressHud(true, animated: true)
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("❌ Error: No userId found in UserDefaults")
            return
        }

        let url = String.dailyBonusPost()

        NetworkManager.shared.showProgressHud(true, animated: true)
        NetworkManager.shared.post(url: url, parameters: nil, headers: nil) { (result: Result<DailyBonusPost>) in
            NetworkManager.shared.showProgressHud(false, animated: false)
            switch result {
            case .success(let response):
                print("✅ Workout saved successfully: \(response)")
            case .failure(let error):
                print("❌ Error saving workout: \(error.localizedDescription)")
            }
        }
    }


    private func updateBonusTimer(with nextBonusTimestamp: TimeInterval) {
        // Find the DailyBonusViewCell and update its timer
        if let dailyBonusCell = collectionView.visibleCells.first(where: { $0 is DailyBonusViewCell }) as? DailyBonusViewCell {
            dailyBonusCell.startBonusTimer(with: nextBonusTimestamp)
        }
    }

    func configureCompositionLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            switch sectionIndex {
//            case 0:
//                return self?.topViewLayout()
            case 0:
                return self?.dailyBonusView()
            case 1:
                return self?.GameView()
            case 2:
                return self?.LeaderBoardView()
            default:
                return self?.defaultLayout()
            }
        }
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }

//    func topViewLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .absolute(112 * Constraint.yCoeff))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .absolute(112 * Constraint.yCoeff)
//        )
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = .init(
//            top: -60 * Constraint.yCoeff,
//            leading: 0 * Constraint.xCoeff,
//            bottom: 0 * Constraint.yCoeff,
//            trailing: 0 * Constraint.xCoeff
//        )
//        return section
//    }

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
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
//        case 0:
//            return 1
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
//        case 0:
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: String(describing: TopViewCell.self),
//                for: indexPath) as? TopViewCell else {
//                return UICollectionViewCell()
//            }
//            if let userData = userData {
//                cell.configure(with: userData)
//            }
//            return cell
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: DailyBonusViewCell.self),
                for: indexPath) as? DailyBonusViewCell else {
                return UICollectionViewCell()
            }
            cell.didPressGetDailyBonus = { [weak self] in
                self?.postDailyBonus()
            }
            return cell
        case 1:
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
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: LeaderBoardViewCell.self),
                for: indexPath) as? LeaderBoardViewCell else {
                return UICollectionViewCell()
            }
            cell.leaderboardUsers = leaderboardUsers
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
