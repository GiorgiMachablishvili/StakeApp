//
//  ExpLabel.swift
//  StakeApp
//
//  Created by Gio's Mac on 21.01.25.
//

import UIKit

class ExpLabel: UILabel {

    // Shared style properties
    static var defaultFont: UIFont = UIFont.montserratMedium(size: 13)
    static var defaultBackgroundColor: UIColor = .userImageGrayBorderColor
    static var defaultTextColor: UIColor = .whiteColor
    static var defaultCornerRadius: CGFloat = 10
    static var defaultTextAlignment: NSTextAlignment = .center
    static var defaultText: String = "1"

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyDefaultStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyDefaultStyle()
    }

    private func applyDefaultStyle() {
        self.font = ExpLabel.defaultFont
        self.backgroundColor = ExpLabel.defaultBackgroundColor
        self.textColor = ExpLabel.defaultTextColor
        self.textAlignment = ExpLabel.defaultTextAlignment
        self.layer.cornerRadius = ExpLabel.defaultCornerRadius
        self.layer.masksToBounds = ExpLabel.defaultCornerRadius > 0
        self.text = ExpLabel.defaultText
    }

    // Update styles globally
    static func updateGlobalStyle(
        font: UIFont? = nil,
        backgroundColor: UIColor? = nil,
        textColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        textAlignment: NSTextAlignment? = nil,
        text: String? = nil
    ) {
        if let font = font { defaultFont = font }
        if let backgroundColor = backgroundColor { defaultBackgroundColor = backgroundColor }
        if let textColor = textColor { defaultTextColor = textColor }
        if let cornerRadius = cornerRadius { defaultCornerRadius = cornerRadius }
        if let textAlignment = textAlignment { defaultTextAlignment = textAlignment }
        if let text = text { defaultText = text }
    }
}
