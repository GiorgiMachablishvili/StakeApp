import UIKit
import SnapKit

class WinOrLoseView: UIView {

    var didPressStartGameButton: (() -> Void)?
    var didPressContinueButton: (() -> Void)?

    lazy var winOrLoseLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "WIN!"
        view.font = UIFont.montserratBold(size: 44)
        view.textColor = UIColor(hexString: "#4E65FD")
        view.textAlignment = .center
        return view
    }()

    lazy var workoutImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(50)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        //        view.isUserInteractionEnabled = true
        return view
    }()

    lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Steve"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        return view
    }()

    lazy var leftPointView: LeftGamePointView = {
        let view = LeftGamePointView()
        view.gameImage.image = UIImage(named: "gold")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var rewardLabel: BonusesStringAttributed = {
        let view = BonusesStringAttributed()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelText = "Your reward"
        return view
    }()

    lazy var bonusButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.gameBonusButton(gameBonusImage: UIImage(named: "consollerImage"))
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var bonusPoints: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "10"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        view.backgroundColor = .buttonBackgroundColor
        view.makeRoundCorners(8)
        view.isHidden = true
        return view
    }()

    lazy var expButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.gameBonusButton(gameBonusImage: UIImage(named: "exp"))
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    private lazy var expLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "EXP"
        view.textColor = .whiteColor
        view.font = UIFont.montserratBold(size: 12)
        view.contentMode = .center
        return view
    }()

    lazy var expPoints: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "1"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        view.backgroundColor = .buttonBackgroundColor
        view.makeRoundCorners(8)
        view.isHidden = true
        return view
    }()

    lazy var redExpButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "redExp"), for: .normal)
        view.backgroundColor = UIColor(hexString: "#5B272D")
        view.makeRoundCorners(28)
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    private lazy var redExpLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "EXP"
        view.textColor = .whiteColor
        view.font = UIFont.montserratBlack(size: 12)
        view.contentMode = .center
        return view
    }()

    lazy var redExpPoints: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "-1"
        view.font = UIFont.montserratBlack(size: 12)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        view.backgroundColor = UIColor(hexString: "#5B272D")
        view.makeRoundCorners(8)
        view.isHidden = true
        return view
    }()


    private lazy var playAgainButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Play again", for: .normal)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(clickPlayAgainButton), for: .touchUpInside)
        return view
    }()

    private lazy var continueButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Continue", for: .normal)
        view.backgroundColor = UIColor.clear
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(clickContinueButton), for: .touchUpInside)
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
        addSubview(winOrLoseLabel)
        addSubview(workoutImage)
        addSubview(nameLabel)
        addSubview(leftPointView)
        addSubview(rewardLabel)
        addSubview(bonusButton)
        addSubview(bonusPoints)
        addSubview(expButton)
        expButton.addSubview(expLabel)
        addSubview(expPoints)
        addSubview(redExpButton)
        redExpButton.addSubview(redExpLabel)
        addSubview(redExpPoints)
        addSubview(playAgainButton)
        addSubview(continueButton)
    }

    private func setupConstraints() {
        winOrLoseLabel.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(20 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(54 * Constraint.yCoeff)
        }

        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(winOrLoseLabel.snp.bottom).offset(32 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100 * Constraint.yCoeff)
        }

        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.bottom).offset(8 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        leftPointView.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.equalTo(36 * Constraint.yCoeff)
            make.width.equalTo(70 * Constraint.xCoeff)
        }

        rewardLabel.snp.remakeConstraints { make in
            make.top.equalTo(leftPointView.snp.bottom).offset(32 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        bonusButton.snp.remakeConstraints { make in
            make.top.equalTo(rewardLabel.snp.bottom).offset(12 * Constraint.yCoeff)
            make.leading.equalTo(snp.leading).offset(115 * Constraint.xCoeff)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        bonusPoints.snp.remakeConstraints { make in
            make.top.equalTo(bonusButton.snp.bottom).offset(-12 * Constraint.yCoeff)
            make.centerX.equalTo(bonusButton.snp.centerX)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.equalTo(25 * Constraint.xCoeff)
        }

        expButton.snp.remakeConstraints { make in
            make.top.equalTo(rewardLabel.snp.bottom).offset(12 * Constraint.yCoeff)
            make.trailing.equalTo(snp.trailing).offset(-115 * Constraint.xCoeff)
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        expLabel.snp.remakeConstraints { make in
            make.center.equalTo(expButton.snp.center)
            make.height.equalTo(9 * Constraint.yCoeff)
            make.width.equalTo(26 * Constraint.xCoeff)
        }

        expPoints.snp.remakeConstraints { make in
            make.top.equalTo(expButton.snp.bottom).offset(-12 * Constraint.yCoeff)
            make.centerX.equalTo(expButton.snp.centerX)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.equalTo(25 * Constraint.xCoeff)
        }

        redExpButton.snp.remakeConstraints { make in
            make.top.equalTo(rewardLabel.snp.bottom).offset(12 * Constraint.yCoeff)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(72 * Constraint.yCoeff)
        }

        redExpLabel.snp.remakeConstraints { make in
            make.center.equalTo(redExpButton.snp.center)
            make.height.equalTo(9 * Constraint.yCoeff)
            make.width.equalTo(26 * Constraint.xCoeff)
        }

        redExpPoints.snp.remakeConstraints { make in
            make.top.equalTo(redExpButton.snp.bottom).offset(-12 * Constraint.yCoeff)
            make.centerX.equalTo(redExpButton.snp.centerX)
            make.height.equalTo(19 * Constraint.yCoeff)
            make.width.equalTo(25 * Constraint.xCoeff)
        }

        playAgainButton.snp.remakeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-104 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }

        continueButton.snp.remakeConstraints { make in
            make.top.equalTo(playAgainButton.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }
    }

    @objc private func clickPlayAgainButton() {
        didPressStartGameButton?()
    }

    @objc private func clickContinueButton() {
        didPressContinueButton?()
    }

}
