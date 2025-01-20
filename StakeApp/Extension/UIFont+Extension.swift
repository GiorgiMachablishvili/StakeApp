//
//  UIFont+Extension.swift
//  StakeApp
//
//  Created by Gio's Mac on 16.01.25.
//

import UIKit

extension UIFont {
    //MARK: font extension
    static func montserratBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size) ?? .systemFont(ofSize: size)
    }

    static func montserratMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: size) ?? .systemFont(ofSize: size)
    }

    static func montserratRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size) ?? .systemFont(ofSize: size)
    }

    static func montserratBlack(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Black", size: size) ?? .systemFont(ofSize: size)
    }
}


