//
//  MainViewControllerTab.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit

class MainViewControllerTab: UITabBarController,  UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.titlesBlack
        self.delegate = self

        navigationItem.hidesBackButton = true
        // Instantiate the three view controllers
        let mainVC = MainView()
        let historyVC = HistoryView()
        let profileVC = ProfileView()

        // Create Navigation Controllers for each (optional for navigation stack)
        let main = UINavigationController(rootViewController: mainVC)
        let history = UINavigationController(rootViewController: historyVC)
        let profile = UINavigationController(rootViewController: profileVC)

        main.navigationBar.isHidden = true
        history.navigationBar.isHidden = true
        profile.navigationBar.isHidden = true

        // Configure tab bar items
        main.tabBarItem = UITabBarItem(
            title: "Main",
            image: resizeImage(
                named: "main", size: CGSize(width: 30 * Constraint.xCoeff, height: 30 * Constraint.yCoeff)
            ),
            tag: 0
        )
        history.tabBarItem = UITabBarItem(
            title: "History",
            image: resizeImage(named: "history", size: CGSize(width: 30 * Constraint.xCoeff, height: 30 * Constraint.yCoeff)),
            tag: 1
        )
        profile.tabBarItem = UITabBarItem(
            title: "Profile",
            image: resizeImage(named: "profile", size: CGSize(width: 30 * Constraint.xCoeff, height: 30 * Constraint.yCoeff)),
            tag: 2
        )

        // Assign view controllers to the Tab Bar
        viewControllers = [main, history, profile]

        main.tabBarItem.imageInsets = UIEdgeInsets(
            top: 0 * Constraint.yCoeff,
            left: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            right: 0 * Constraint.xCoeff
        )
        history.tabBarItem.imageInsets = UIEdgeInsets(
            top: 0 * Constraint.yCoeff,
            left: 0,
            bottom: 0 * Constraint.yCoeff,
            right: 0
        )
        profile.tabBarItem.imageInsets = UIEdgeInsets(
            top: 0 * Constraint.yCoeff,
            left: 0 * Constraint.xCoeff,
            bottom: 0 * Constraint.yCoeff,
            right: 0 * Constraint.xCoeff
        )

        // Style the Tab Bar (optional)
        tabBar.tintColor = .whiteColor
        tabBar.unselectedItemTintColor = .whiteColor.withAlphaComponent(0.4) // Color for unselected tabs
        tabBar.barTintColor = UIColor.titlesBlack
        tabBar.isTranslucent = false
    }

    private func resizeImage(named: String, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: named) else { return nil }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
