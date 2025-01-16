//
//  UICornerRadius.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit

extension UIView {
    func makeRoundCorners(_ radius: CGFloat) {
        self.layer.cornerRadius = radius  * Constraint.xCoeff
        self.layer.masksToBounds = true
    }
}
