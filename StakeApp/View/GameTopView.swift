import UIKit
import SnapKit

class GameTopView: UIView {

    var pressPauseButton: (()-> Void)?

    private lazy var pauseButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "pauseButton"), for: .normal)
        view.makeRoundCorners(20)
        view.addTarget(self, action: #selector(clickPauseButton), for: .touchUpInside)
        return view
    }()

    lazy var pointView: PointsView = {
        let view = PointsView()
        view.backgroundColor = .pointViewColor
        view.makeRoundCorners(16)
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
        addSubview(pauseButton)
        addSubview(pointView)
    }

    private func setupConstraints() {
        pauseButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-16 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(16 * Constraint.xCoeff)
            make.width.height.equalTo(40 * Constraint.yCoeff)
        }

        pointView.snp.remakeConstraints { make in
            make.centerY.equalTo(pauseButton.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-16 * Constraint.xCoeff)
            make.height.equalTo(40 * Constraint.yCoeff)
            make.width.equalTo(85 * Constraint.xCoeff)
        }
    }

    @objc private func clickPauseButton() {
        pressPauseButton?()
    }
}
