import UIKit
import SnapKit

extension UIView {
    /// Configure the view with an image, title, and additional info
    func configureView(image: UIImage?, title: String, viewInfo: String) {
        // Remove all existing subviews
        subviews.forEach { $0.removeFromSuperview() }

        // Image View
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.montserratBold(size: 12)
        titleLabel.textColor = .whiteColor
        titleLabel.textAlignment = .left

        // Info Label
        let infoLabel = UILabel()
        infoLabel.text = viewInfo
        infoLabel.font = UIFont.montserratMedium(size: 10)
        infoLabel.textColor = .grayLabel
        infoLabel.textAlignment = .left
        infoLabel.numberOfLines = 2

        // Add subviews
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(infoLabel)

        // Layout using Auto Layout
        imageView.snp.remakeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(snp.leading).offset(12 * Constraint.xCoeff)
            make.height.width.equalTo(44 * Constraint.yCoeff)
        }

        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(18.5 * Constraint.yCoeff)
            make.leading.equalTo(imageView.snp.trailing).offset(12 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        infoLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4 * Constraint.yCoeff)
            make.leading.equalTo(imageView.snp.trailing).offset(12 * Constraint.xCoeff)
            make.width.equalTo(266 * Constraint.yCoeff)
        }
    }
}

