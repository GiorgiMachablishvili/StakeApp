import UIKit
import SnapKit

class BonusCostView: UIView {

    private lazy var backgroundTopView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(8)
        view.backgroundColor = UIColor.bonusCostViewBackground
        return view
    }()

    private lazy var consoleImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "consoller")
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var costLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "5"
        view.textColor = UIColor.whiteColor
        view.font = UIFont.montserratBold(size: 14)
        view.textAlignment = .left
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(backgroundTopView)
        backgroundTopView.addSubview(costLabel)
        backgroundTopView.addSubview(consoleImage)
    }

    private func setupConstraints() {
        backgroundTopView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        consoleImage.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundTopView.snp.centerY)
            make.leading.equalTo(backgroundTopView.snp.leading).offset(6 * Constraint.xCoeff)
            make.height.width.equalTo(12 * Constraint.yCoeff)
        }

        costLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(backgroundTopView.snp.centerY)
            make.leading.equalTo(consoleImage.snp.trailing).offset(2 * Constraint.xCoeff)
            make.trailing.equalTo(backgroundTopView.snp.trailing).offset(-2 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }
    }
}


