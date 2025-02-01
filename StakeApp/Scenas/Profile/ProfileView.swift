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

    private var userData: UserDataResponse?
    private var userGameStats: UserGameStats?

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
        view.didPressSaveButton = { [weak self] in
            self?.updateUserInfo()
        }
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

//        fetchUserData()
        fetchUserGameStatistic()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
    }

    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(backgroundProfileView)
        backgroundProfileView.addSubview(profileView)
    }

    private func setupConstraint() {
        collectionView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(60 * Constraint.yCoeff)
        }

        backgroundProfileView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(80 * Constraint.yCoeff)
            make.height.equalTo(478 * Constraint.yCoeff)
        }
    }

    func setupHierarchy() {
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: String(describing: TopCell.self))
        collectionView.register(EditProfileCell.self, forCellWithReuseIdentifier: String(describing: EditProfileCell.self))
        collectionView.register(StaticCell.self, forCellWithReuseIdentifier: String(describing: StaticCell.self))
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: String(describing: SettingCell.self))
        collectionView.register(LeaderBoardCell.self, forCellWithReuseIdentifier: String(describing: LeaderBoardCell.self))
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
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
            }
        }
    }

    private func fetchUserGameStatistic() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }

        let url = String.getUserGameStatistic(userId: userId)
        NetworkManager.shared.get(url: url, parameters: nil, headers: nil) { (result: Result<UserGameStats>) in
            switch result {
            case .success(let response):
                self.userGameStats = response
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch user game stats: \(error)")
            }
        }
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
            top: -60 * Constraint.yCoeff,
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
        self.tabBarController?.tabBar.isHidden = false
    }

    @objc private func updateUserInfo() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("userId not found or not an Int")
            return
        }
        // Get the selected image and nickname from the profile view
        let selectedImage = profileView.selectedImage
        let nickname = profileView.nicknameTextField.text

        // Show loading indicator
        NetworkManager.shared.showProgressHud(true, animated: true)

        // Send the PATCH request
        NetworkManager.shared.updateUserProfile(userId: userId, image: selectedImage, nickname: nickname) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                NetworkManager.shared.showProgressHud(false, animated: false)
            }

            switch result {
            case .success(let userData):
                // Update the UI with the new user data
                self.userData = userData
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.hideView() // Hide the edit profile view
                }
            case .failure(let error):
                print("Failed to update user profile: \(error)")
                // Show an error message to the user
                self.showAlert(title: "Error", message: "Failed to update profile. Please try again.")
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
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
            if let userData = userData {
                cell.configure(with: userData)
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: EditProfileCell.self),
                for: indexPath) as? EditProfileCell else {
                return UICollectionViewCell()
            }
            if let userData = userData {
                cell.configure(with: userData)
            }
            cell.didPressEditProfileButton = { [weak self] image in
                guard let self = self else { return }
                self.backgroundProfileView.isHidden = false
                self.profileView.isHidden = false
                self.tabBarController?.tabBar.isHidden = true

                // Pass the image to EditProfileView
                self.profileView.workoutImage.image = image
                self.profileView.selectedImage = image

                //            cell.didPressEditProfileButton = { [weak self] in
//                guard let self = self else { return }
//                backgroundProfileView.isHidden = false
//                profileView.isHidden = false
//                self.tabBarController?.tabBar.isHidden = true
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: StaticCell.self),
                for: indexPath) as? StaticCell else {
                return UICollectionViewCell()
            }
            if let stats = userGameStats {
                cell.configure(user: stats)
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


//extension ProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        // Get the selected image
//        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
//            profileView.workoutImage.image = selectedImage // Update the image view
//            // You can also use the `didUpdateImage` callback if needed
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}

extension ProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        // Get the selected image
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            profileView.workoutImage.image = selectedImage // Update the image view
            profileView.selectedImage = selectedImage // Store the selected image
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
