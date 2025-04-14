import UIKit
import SnapKit
import Kingfisher

class DailyGameCell: UICollectionViewCell {
    private lazy var dataLabel: BonusesStringAttributed = {
        let view = BonusesStringAttributed()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelText = "02/02/2024"
        return view
    }()

    private lazy var backgroundDailyGameView: UIView = {
        let view = UIView(frame: .zero)
        view.makeRoundCorners(24)
        view.backgroundColor = UIColor.titlesBlack
        return view
    }()

    private lazy var timeLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "12:24PM"
        view.font = UIFont.montserratBold(size: 10)
        view.textColor = UIColor.whiteColor.withAlphaComponent(0.25)
        view.textAlignment = .left
        return view
    }()

    private lazy var gameTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "PANDAS AND BABOONS"
        view.font = UIFont.montserratBold(size: 10)
        view.textColor = UIColor(hexString: "#687CFF")
        view.textAlignment = .center
        return view
    }()

    private lazy var winOrLossLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "WIN"
        view.font = UIFont.montserratBold(size: 10)
        view.textColor = UIColor.whiteColor.withAlphaComponent(0.25)
        view.textAlignment = .left
        return view
    }()

    private lazy var vsLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "VS"
        view.font = UIFont.montserratBold(size: 16)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .center
        return view
    }()

    private lazy var userImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        return view
    }()

    lazy var userLevelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.montserratMedium(size: 13)
        view.backgroundColor = .userImageGrayBorderColor
        view.textColor = .whiteColor
        view.textAlignment = .center
        view.makeRoundCorners(10)
        view.text = "1"
        return view
    }()

    private lazy var userName: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Tedo"
        view.font = UIFont.montserratBold(size: 12)
        view.textColor = UIColor.whiteColor.withAlphaComponent(0.25)
        view.textAlignment = .left
        return view
    }()

    private lazy var opponentImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.titlesBlack
        view.makeRoundCorners(24)
        view.contentMode = .center
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "avatar")
        return view
    }()

    lazy var opponentLevelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.montserratMedium(size: 13)
        view.backgroundColor = .userImageGrayBorderColor
        view.textColor = .whiteColor
        view.textAlignment = .center
        view.makeRoundCorners(10)
        view.text = "1"
        return view
    }()

    private lazy var opponentName: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Kote"
        view.font = UIFont.montserratBold(size: 13)
        view.textColor = UIColor.whiteColor.withAlphaComponent(0.25)
        view.textAlignment = .right
        return view
    }()

    private lazy var leftPointView: LeftGamePointView = {
        let view = LeftGamePointView()
        view.contentMode = .scaleAspectFit
        view.makeRoundCorners(14)
        view.backgroundColor = UIColor.clear
        view.pointLabel.textAlignment = .left
        return view
    }()

    private lazy var rightPointView: RightGamePointView = {
        let view = RightGamePointView()
        view.contentMode = .scaleAspectFit
        view.makeRoundCorners(14)
        view.backgroundColor = UIColor.clear
        view.pointLabel.textAlignment = .right
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

        addSubview(backgroundDailyGameView)
        backgroundDailyGameView.addSubview(dataLabel)
        backgroundDailyGameView.addSubview(timeLabel)
        backgroundDailyGameView.addSubview(gameTitle)
        backgroundDailyGameView.addSubview(winOrLossLabel)
        backgroundDailyGameView.addSubview(vsLabel)
        backgroundDailyGameView.addSubview(userImage)
        backgroundDailyGameView.addSubview(userLevelLabel)
        backgroundDailyGameView.addSubview(userName)
        backgroundDailyGameView.addSubview(opponentImage)
        backgroundDailyGameView.addSubview(opponentLevelLabel)
        backgroundDailyGameView.addSubview(opponentName)
        backgroundDailyGameView.addSubview(leftPointView)
        backgroundDailyGameView.addSubview(rightPointView)
    }

    private func setupConstraints() {
        dataLabel.snp.remakeConstraints { make in
            make.top.equalTo(backgroundDailyGameView.snp.top).offset(5 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        backgroundDailyGameView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16 * Constraint.xCoeff)
            make.height.equalTo(160 * Constraint.yCoeff)
        }

        timeLabel.snp.remakeConstraints { make in
            make.top.equalTo(dataLabel.snp.bottom).offset(4 * Constraint.yCoeff)
            make.leading.equalTo(backgroundDailyGameView.snp.leading).offset(24 * Constraint.xCoeff)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        gameTitle.snp.remakeConstraints { make in
            make.centerX.equalTo(backgroundDailyGameView.snp.centerX)
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        winOrLossLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.trailing.equalTo(backgroundDailyGameView.snp.trailing).offset(-24 * Constraint.xCoeff)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        vsLabel.snp.remakeConstraints { make in
            make.top.equalTo(gameTitle.snp.bottom).offset(30 * Constraint.yCoeff)
            make.centerX.equalTo(backgroundDailyGameView.snp.centerX)
            make.height.equalTo(20 * Constraint.yCoeff)
            make.width.equalTo(22 * Constraint.xCoeff)
        }

        userName.snp.remakeConstraints { make in
            make.centerY.equalTo(vsLabel.snp.centerY)
            make.leading.equalTo(userImage.snp.trailing).offset(12 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        userImage.snp.remakeConstraints { make in
            make.centerY.equalTo(vsLabel.snp.centerY)
            make.leading.equalTo(backgroundDailyGameView.snp.leading).offset(16 * Constraint.xCoeff)
            make.height.width.equalTo(56 * Constraint.yCoeff)
        }

        userLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(userImage.snp.top).offset(40 * Constraint.yCoeff)
            make.leading.equalTo(userImage.snp.leading).offset(40 * Constraint.xCoeff)
            make.height.width.equalTo(20 * Constraint.yCoeff)
        }

        opponentName.snp.remakeConstraints { make in
            make.centerY.equalTo(vsLabel.snp.centerY)
            make.trailing.equalTo(opponentImage.snp.leading).offset(-12 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }

        opponentImage.snp.remakeConstraints { make in
            make.centerY.equalTo(vsLabel.snp.centerY)
            make.trailing.equalTo(backgroundDailyGameView.snp.trailing).offset(-16 * Constraint.xCoeff)
            make.height.width.equalTo(56 * Constraint.yCoeff)
        }

        opponentLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(opponentImage.snp.top).offset(40 * Constraint.yCoeff)
            make.leading.equalTo(opponentImage.snp.leading).offset(40 * Constraint.xCoeff)
            make.height.width.equalTo(20 * Constraint.yCoeff)
        }

        leftPointView.snp.remakeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(12 * Constraint.yCoeff)
            make.leading.equalTo(backgroundDailyGameView.snp.leading).offset(16 * Constraint.xCoeff)
            make.height.equalTo(36 * Constraint.yCoeff)
            make.width.equalTo(75 * Constraint.xCoeff)
        }

        rightPointView.snp.remakeConstraints { make in
            make.top.equalTo(opponentImage.snp.bottom).offset(12 * Constraint.yCoeff)
            make.trailing.equalTo(backgroundDailyGameView.snp.trailing).offset(-16 * Constraint.xCoeff)
            make.height.equalTo(36 * Constraint.yCoeff)
            make.width.equalTo(75 * Constraint.yCoeff)
        }
    }

    private func formatDate(_ isoDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MMM/yy"
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.locale = Locale(identifier: "en_US")

        if let date = inputFormatter.date(from: isoDate) {
            return outputFormatter.string(from: date).uppercased()
        } else {
            return "Invalid Date"
        }
    }


    func configure(with userData: UserGameHistory) {
        timeLabel.text = "\(userData.time)"
        dataLabel.labelText = formatDate(userData.date)
        gameTitle.text = userData.gameName
        winOrLossLabel.text = userData.result ? "WIN" : "LOSE"
        userImage.kf.setImage(with: URL(string: userData.userImage ?? ""), placeholder: UIImage(named: "avatar"))
        userLevelLabel.text  = "\(userData.userLevel ?? 1)"
        userName.text = userData.userName
        opponentImage.kf.setImage(with: URL(string: userData.opponentImage ?? ""), placeholder: UIImage(named: "avatar"))
        opponentLevelLabel.text = "\(userData.opponentLevel ?? 1)"
        opponentName.text = userData.opponentName
        leftPointView.pointLabel.text = "\(userData.userGameScore)"
        rightPointView.pointLabel.text = "\(userData.opponentGameScore)"

        if userData.gameName == "MINERS" {
            leftPointView.gameImage.image = UIImage(named: "gold")
            rightPointView.gameImage.image = UIImage(named: "gold")
        } else if userData.gameName == "PANDAS AND BABOONS" {
            leftPointView.gameImage.image = UIImage(named: "bamboImage")
            rightPointView.gameImage.image = UIImage(named: "bamboImage")
        }
    }
}
