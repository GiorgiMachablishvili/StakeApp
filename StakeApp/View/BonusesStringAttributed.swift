//
//  BonusesLabel.swift
//  StakeApp
//
//  Created by Gio's Mac on 17.01.25.
//

import UIKit

class BonusesStringAttributed: UILabel {

    // Custom text property to update and redraw
    var labelText: String = "Bonuses" {
        didSet {
            setNeedsDisplay() // Trigger a redraw when the text changes
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // Text attributes
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratBold(size: 12),
            .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)
        ]

        // Calculate text size
        let textSize = labelText.size(withAttributes: textAttributes)

        // Draw text in the center
        let textX = (rect.width - textSize.width) / 2
        let textY = (rect.height - textSize.height) / 2
        labelText.draw(at: CGPoint(x: textX, y: textY), withAttributes: textAttributes)

        // Line attributes
        let lineWidth: CGFloat = 1.0
        let lineColor = UIColor.white.withAlphaComponent(0.5)
        let lineY = textY + textSize.height / 2 // Center of the text

        // Draw left line
        let leftLineStart = CGPoint(x: 0, y: lineY)
        let leftLineEnd = CGPoint(x: textX - 8, y: lineY) // Add some spacing from text
        drawLine(from: leftLineStart, to: leftLineEnd, color: lineColor, lineWidth: lineWidth)

        // Draw right line
        let rightLineStart = CGPoint(x: textX + textSize.width + 8, y: lineY) // Add some spacing from text
        let rightLineEnd = CGPoint(x: rect.width, y: lineY)
        drawLine(from: rightLineStart, to: rightLineEnd, color: lineColor, lineWidth: lineWidth)
    }

    private func drawLine(from start: CGPoint, to end: CGPoint, color: UIColor, lineWidth: CGFloat) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
    }
}

