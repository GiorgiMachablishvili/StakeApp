import UIKit
import SnapKit

class GameTimerScoreView: UIView {
    var timerDidFinish: (() -> Void)?
    var onTimeUpdate: ((Int) -> Void)?

    var opponentLevel: Int = Int.random(in: 1...30) // Store it in a property

    private func setOpponentLevel() {
        opponentLevel = Int.random(in: 1...30) // Generate once when setting up
        opponentLevelLabel.text = "\(opponentLevel)"
    }

    private var timer: Timer?
    var remainingSeconds: Int = 60 {
        didSet {
            timerLabel.text = "\(remainingSeconds)"
        }
    }

    lazy var leftArrow: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "leftArrow")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var timerLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "\(remainingSeconds)"
        view.font = UIFont.montserratBold(size: 14)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(22)
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.buttonBackgroundColor.cgColor
        return view
    }()

    lazy var rightArrow: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "rightArrow")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var userImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        return view
    }()

    lazy var userBlockedImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "blocked")
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    lazy var useLevelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.montserratMedium(size: 13)
        view.backgroundColor = .userImageGrayBorderColor
        view.textColor = .whiteColor
        view.textAlignment = .center
        view.makeRoundCorners(10)
        view.text = "1"
        return view
    }()

    lazy var userName: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Tedo"
        view.font = UIFont.montserratBold(size: 13)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    lazy var opponentImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        return view
    }()

    lazy var opponentBlockedImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "blocked")
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    lazy var opponentLevelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.montserratMedium(size: 13)
        view.backgroundColor = .userImageGrayBorderColor
        view.textColor = .whiteColor
        view.textAlignment = .center
        view.makeRoundCorners(10)
        return view
    }()


    lazy var opponentName: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "User_\(Int.random(in: 123...900))"
        view.font = UIFont.montserratBold(size: 13)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    lazy var leftPointView: LeftGamePointView = {
        let view = LeftGamePointView()
        view.gameImage.image = UIImage(named: "gold")
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var rightPointView: RightGamePointView = {
        let view = RightGamePointView()
        view.gameImage.image = UIImage(named: "gold")
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
        startTimer()

        setOpponentLevel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(leftArrow)
        addSubview(timerLabel)
        addSubview(rightArrow)
        addSubview(userImage)
        addSubview(userBlockedImage)
        addSubview(useLevelLabel)
        addSubview(userName)
        addSubview(opponentImage)
        addSubview(opponentBlockedImage)
        addSubview(opponentLevelLabel)
        addSubview(opponentName)
        addSubview(leftPointView)
        addSubview(rightPointView)
    }

    private func setupConstraints() {
        leftArrow.snp.remakeConstraints { make in
            make.centerY.equalTo(timerLabel.snp.centerY)
            make.trailing.equalTo(timerLabel.snp.leading)
            make.height.equalTo(12 * Constraint.yCoeff)
            make.width.equalTo(16 * Constraint.yCoeff)
        }

        timerLabel.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(44 * Constraint.yCoeff)
        }

        rightArrow.snp.remakeConstraints { make in
            make.centerY.equalTo(timerLabel.snp.centerY)
            make.leading.equalTo(timerLabel.snp.trailing)
            make.height.equalTo(12 * Constraint.yCoeff)
            make.width.equalTo(16 * Constraint.yCoeff)
        }

        userImage.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16 * Constraint.xCoeff)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(60 * Constraint.yCoeff)
        }

        userBlockedImage.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16 * Constraint.xCoeff)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(60 * Constraint.yCoeff)
        }

        useLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(userImage.snp.top).offset(40 * Constraint.yCoeff)
            make.leading.equalTo(userImage.snp.leading).offset(40 * Constraint.xCoeff)
            make.height.width.equalTo(20 * Constraint.yCoeff)
        }

        userName.snp.remakeConstraints { make in
            make.top.equalTo(userImage.snp.top)
            make.leading.equalTo(userImage.snp.trailing).offset(8 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        leftPointView.snp.remakeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(4 * Constraint.yCoeff)
            make.leading.equalTo(userImage.snp.trailing).offset(8 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
            make.width.equalTo(65 * Constraint.xCoeff)
        }

        opponentImage.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-16 * Constraint.xCoeff)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(60 * Constraint.yCoeff)
        }

        opponentBlockedImage.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-16 * Constraint.xCoeff)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(60 * Constraint.yCoeff)
        }

        opponentLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(opponentImage.snp.top).offset(40 * Constraint.yCoeff)
            make.leading.equalTo(opponentImage.snp.leading).offset(40 * Constraint.xCoeff)
            make.height.width.equalTo(20 * Constraint.yCoeff)
        }

        opponentName.snp.remakeConstraints { make in
            make.top.equalTo(opponentImage.snp.top)
            make.trailing.equalTo(opponentImage.snp.leading).offset(-8 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        rightPointView.snp.remakeConstraints { make in
            make.top.equalTo(opponentName.snp.bottom).offset(4 * Constraint.yCoeff)
            make.trailing.equalTo(opponentImage.snp.leading).offset(-8 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
            make.width.equalTo(65 * Constraint.xCoeff)
        }
    }
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }

    func resetTimer(to seconds: Int) {
        pauseTimer()
        remainingSeconds = seconds
        startTimer()
    }

    @objc private func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            onTimeUpdate?(remainingSeconds)
        } else {
            pauseTimer()
            timerDidFinish?()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
