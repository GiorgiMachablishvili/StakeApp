//
//  HistoryView.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit
import SnapKit

class HistoryView: UIViewController {

//    private var viewModel = HistoryViewModel(collectionView: collectionView)

    private var viewModel: HistoryViewModelType?
//
//    init(viewModel: HistoryViewModelType = HistoryViewModel(), userData: UserDataResponse? = nil, userHistoryInfo: UserGameHistory? = nil, userHistoryList: [UserGameHistory]) {
//        self.viewModel = viewModel
//        self.userData = userData
//        self.userHistoryInfo = userHistoryInfo
//        self.userHistoryList = userHistoryList
//    }

    private lazy var topView: MainTopView = {
        let view = MainTopView()
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        
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

        viewModel = HistoryViewModel(collectionView: collectionView)
        viewModel?.viewDidLoad()

        setup()
        setupConstraint()
        setupHierarchy()
        configureCompositionLayout()

        hideOrNotEmptyLabel()
        
        viewModel?.didUpdataData = { [weak self] userData in
            self?.topView.configure(with: userData)
        }
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
        collectionView.register(DailyGameCell.self, forCellWithReuseIdentifier: String(describing: DailyGameCell.self))
    }

    func hideOrNotEmptyLabel() {
        viewModel?.updataEmptyStat = { [weak self] userHistoryList in
            self?.emptyLabel.isHidden = !userHistoryList.isEmpty
            self?.emptyLabelInfo.isHidden = !userHistoryList.isEmpty
        }
    }


    func configureCompositionLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            switch sectionIndex {
            case 0:
                return self?.dailyGameView()
            default:
                return self?.defaultLayout()
            }
        }
        self.collectionView.setCollectionViewLayout(layout, animated: false)
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

