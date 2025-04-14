import UIKit
import SnapKit

extension UIButton {
    func gameBonusButton(gameBonusImage: UIImage?) {
        self.subviews.forEach { $0.removeFromSuperview() }

        let imageBackgroundView = UIView()
        imageBackgroundView.backgroundColor = UIColor(hexString: "#272E5B")
        imageBackgroundView.makeRoundCorners(28)
        imageBackgroundView.isUserInteractionEnabled = true

        let gameImageView = UIImageView(image: gameBonusImage)
        gameImageView.contentMode = .scaleToFill
        gameImageView.isUserInteractionEnabled = true

        self.addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(gameImageView)

        imageBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        gameImageView.snp.makeConstraints { make in
            make.center.equalTo(imageBackgroundView.snp.center)
            make.height.equalTo(50 * Constraint.yCoeff)
            make.width.equalTo(46 * Constraint.xCoeff)
        }

        self.clipsToBounds = true
    }
}
