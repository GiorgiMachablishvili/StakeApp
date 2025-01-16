//
//  Constraint.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit

class Constraint {
    static let deviceHeight = UIScreen.main.bounds.height
    static let deviceWidth = UIScreen.main.bounds.width

    //MARK: figma file device width 375
    static var xCoeff: CGFloat {
        return deviceWidth / 390
    }

    //MARK: figma file device height 812
    static var yCoeff: CGFloat {
        return deviceHeight / 844
    }
}

