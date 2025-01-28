//
//  UITabBarHideOrNot+Extension.swift
//  StakeApp
//
//  Created by Gio's Mac on 28.01.25.
//

import UIKit

extension UITabBarController {
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        let tabBarHeight: CGFloat = tabBar.frame.size.height
        let tabBarPositionY: CGFloat = UIScreen.main.bounds.height - (hidden ? 0 : tabBarHeight)

        guard animated else {
            tabBar.frame.origin.y = tabBarPositionY
            return
        }

        UIView.animate(withDuration: duration) {
            self.tabBar.frame.origin.y = tabBarPositionY
        }
    }
}
