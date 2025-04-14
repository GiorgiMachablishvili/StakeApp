import UIKit
import SnapKit
import Kingfisher

class EditProfileCell: UICollectionViewCell {

    var didPressEditProfileButton: ((UIImage?) -> Void)?

    private lazy var workoutImage: UIImageView = {
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

    lazy var userLevelLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.montserratMedium(size: 16)
        view.backgroundColor = .userImageGrayBorderColor
        view.textColor = .whiteColor
        view.textAlignment = .center
        view.makeRoundCorners(16)
        view.text = "1"
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Steve"
        view.font = UIFont.montserratBold(size: 13)
        view.textColor = UIColor.whiteColor
        view.textAlignment = .left
        return view
    }()

    private lazy var expLabel: UILabel = {
        let view = UILabel()
        view.attributedText = createExpAttributedString()
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()

    private lazy var editProfileButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = UIColor.buttonBackgroundColor
        view.setTitle("Edit Profile", for: .normal)
        view.setTitleColor(UIColor.whiteColor, for: .normal)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(pressEditProfileButton), for: .touchUpInside)
        return view
    }()

    private lazy var pointView: PointsView = {
        let view = PointsView()
        view.backgroundColor = .pointViewColor
        view.makeRoundCorners(16)
        view.isHidden = true
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
        addSubview(workoutImage)
        addSubview(userLevelLabel)
        addSubview(nameLabel)
        addSubview(expLabel)
        addSubview(editProfileButton)
        addSubview(pointView)
    }

    private func setupConstraints() {
        workoutImage.snp.remakeConstraints { make in
            make.top.equalTo(snp.top).offset(2 * Constraint.yCoeff)
            make.centerX.equalTo(snp.centerX)
            make.height.width.equalTo(100 * Constraint.yCoeff)
        }

        userLevelLabel.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.top).offset(68 * Constraint.yCoeff)
            make.leading.equalTo(workoutImage.snp.leading).offset(68 * Constraint.xCoeff)
            make.height.width.equalTo(32 * Constraint.yCoeff)
        }

        nameLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(workoutImage.snp.centerX)
            make.top.equalTo(workoutImage.snp.bottom).offset(8 * Constraint.yCoeff)
            make.height.equalTo(20 * Constraint.yCoeff)
        }

        expLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(workoutImage.snp.centerX)
            make.top.equalTo(nameLabel.snp.bottom).offset(8 * Constraint.yCoeff)
            make.height.equalTo(12 * Constraint.yCoeff)
        }

        editProfileButton.snp.remakeConstraints { make in
            make.centerX.equalTo(workoutImage.snp.centerX)
            make.top.equalTo(expLabel.snp.bottom).offset(8 * Constraint.yCoeff)
            make.height.equalTo(39 * Constraint.yCoeff)
            make.width.equalTo(163 * Constraint.xCoeff)
        }

        pointView.snp.remakeConstraints { make in
            make.top.equalTo(workoutImage.snp.top)
            make.leading.equalTo(workoutImage.snp.trailing).offset(60)
            make.height.width.equalTo(5)
        }
    }

    func createExpAttributedString() -> NSAttributedString {
        let expAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratMedium(size: 10),
            .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)
        ]
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratMedium(size: 10),
            .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)
        ]
        // Create the attributed strings
        let expString = NSAttributedString(string: "EXP ", attributes: expAttributes)
        let numberString = NSAttributedString(string: "0/20", attributes: numberAttributes)
        // Combine the two strings
        let combinedString = NSMutableAttributedString()
        combinedString.append(expString)
        combinedString.append(numberString)
        return combinedString
    }

    @objc private func pressEditProfileButton() {
//        didPressEditProfileButton?()
        didPressEditProfileButton?(workoutImage.image)
    }

    func updateExperiencePoints(add value: Int) {
        guard let expText = expLabel.attributedText?.string else { return }

        // Extract current experience and level
        let currentExp = Int(expText.components(separatedBy: " ")[1].split(separator: "/")[0]) ?? 0
        let currentLevel = Int(userLevelLabel.text ?? "1") ?? 1
        var newExp = value

//        // Handle leveling up
//        if newExp >= 20 {
//            let levelsToAdd = newExp / 20
//            newExp = newExp % 20 // Remaining experience after leveling up
//            ExpLabel.defaultText = "\(currentLevel + levelsToAdd)"
//            userLevelLabel.text = ExpLabel.defaultText // Update level label
//        }

        // Update the attributed text for experience points
        let updatedExpString = NSMutableAttributedString()
        updatedExpString.append(NSAttributedString(string: "EXP ", attributes: [.font: UIFont.montserratMedium(size: 10), .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)]))
        updatedExpString.append(NSAttributedString(string: "\(newExp)", attributes: [.font: UIFont.montserratMedium(size: 10), .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)]))
        updatedExpString.append(NSAttributedString(string: "/20", attributes: [.font: UIFont.montserratMedium(size: 10), .foregroundColor: UIColor.whiteColor.withAlphaComponent(0.3)]))

        expLabel.attributedText = updatedExpString
    }

    func configureEditProfileButton(forGuest isGuestUser: Bool) {
        editProfileButton.isUserInteractionEnabled = !isGuestUser
        editProfileButton.alpha = isGuestUser ? 0.5 : 1.0
    }


    func configure(with userData: UserDataResponse) {
        nameLabel.text = userData.username
        userLevelLabel.text = "\(userData.level)"
        updateExperiencePoints(add: userData.experience)
        pointView.pointLabel.text = "\(userData.points)"
        if let imageUrl = URL(string: userData.image) {
            workoutImage.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(named: "avatar"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            workoutImage.image = UIImage(named: "avatar")
        }
    }
}
