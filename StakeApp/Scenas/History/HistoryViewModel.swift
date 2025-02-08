//
//  HistoryViewModel.swift
//  StakeApp
//
//  Created by Gio's Mac on 06.02.25.
//

import UIKit

protocol HistoryViewModelType {
    func fetchUserData()
    func getUserDataResponse() -> UserDataResponse?
    func fetchUserGameHistory()
    func viewDidLoad()

    var didUpdataData: ((UserDataResponse) -> Void)? { get set }
    var updataEmptyStat: (([UserGameHistory]) -> Void)? { get set }
}

class HistoryViewModel: NSObject, HistoryViewModelType {
    var didUpdataData: ((UserDataResponse) -> Void)?
    var updataEmptyStat: (([UserGameHistory]) -> Void)?

    private var userData: UserDataResponse?
    private var collectionView: UICollectionView
    private var userHistoryList: [UserGameHistory] = []

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func fetchUserData() {
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
                    self.didUpdataData?(userData)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
            }
        }
    }

    func getUserDataResponse() -> UserDataResponse? {
        return userData
    }

    func fetchUserGameHistory() {
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
//                    self.hideOrNotEmptyLabel()
                    self.updataEmptyStat?(userHistoryList)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
            }
        }
    }

    func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUserData()
        fetchUserGameHistory()
    }
}

extension HistoryViewModel: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return userHistoryList.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
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

