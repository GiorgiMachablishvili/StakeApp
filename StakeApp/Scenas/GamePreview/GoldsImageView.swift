import UIKit
import SnapKit

class GoldsImageView: UIView {

    private lazy var bigGoldImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "goldImageBig")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var middleGoldImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "middleGoldImage")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var smallGoldImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "smallGoldImage")
        view.contentMode = .scaleAspectFit
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
        addSubview(bigGoldImage)
        addSubview(middleGoldImage)
        addSubview(smallGoldImage)
    }

    private func setupConstraints() {
        bigGoldImage.snp.remakeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.bottom.equalTo(snp.bottom)
            make.width.height.equalTo(92 * Constraint.xCoeff)
        }

        middleGoldImage.snp.remakeConstraints { make in
            make.top.equalTo(snp.top)
            make.leading.equalTo(snp.leading).offset(88 * Constraint.xCoeff)
            make.width.height.equalTo(53 * Constraint.yCoeff)
        }

        smallGoldImage.snp.remakeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(-2 * Constraint.xCoeff)
            make.top.equalTo(snp.top).offset(31 * Constraint.xCoeff)
            make.height.width.equalTo(40 * Constraint.yCoeff)
        }
    }

    
}
