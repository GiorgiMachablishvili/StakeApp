import UIKit
import SnapKit

class FindingAnOpponentsController: UIViewController {

    var nextViewController: UIViewController?
    private let viewModel = FindingAnOpponentsViewModel()

    private lazy var findingTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Finding an opponent"
        view.font = UIFont.montserratBlack(size: 20)
        view.textAlignment = .center
        view.textColor = .whiteColor
        return view
    }()

    private lazy var findingInfoTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Looking for an opponent for you, this will take some time"
        view.font = UIFont.montserratBold(size: 12)
        view.textAlignment = .center
        view.textColor = .grayLabel
        view.numberOfLines = 2
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Cancel", for: .normal)
        view.backgroundColor = UIColor.whiteColor.withAlphaComponent(0.15)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainViewsBackViewBlack

        setup()
        setupConstraints()
        bindViewModel()

        viewModel.startFindingOpponent(after: 3.0)
    }

    private func setup() {
        view.addSubview(findingTitle)
        view.addSubview(findingInfoTitle)
        view.addSubview(cancelButton)
    }

    private func setupConstraints() {
        findingTitle.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(387 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(57 * Constraint.xCoeff)
            make.height.equalTo(24 * Constraint.yCoeff)
        }

        findingInfoTitle.snp.remakeConstraints { make in
            make.top.equalTo(findingTitle.snp.bottom).offset(16 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(57 * Constraint.xCoeff)
            make.height.equalTo(30 * Constraint.yCoeff)
        }

        cancelButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-78 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }
    }

    private func bindViewModel() {
        // Update UI with dot animation
        viewModel.onDotsUpdated = { [weak self] text in
            self?.findingTitle.text = text
        }

        // Navigate when opponent is found
        viewModel.onOpponentFound = { [weak self] in
            guard let self = self, let nextVC = self.nextViewController else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    @objc private func clickCancelButton() {
        viewModel.cancelFinding()
        navigationController?.popViewController(animated: true)
    }
}


//import UIKit
//import SnapKit
//
//class FindingAnOpponentsController: UIViewController {
//
//    var nextViewController: UIViewController?
//
//    private lazy var findingTitle: UILabel = {
//        let view = UILabel(frame: .zero)
//        view.text = "Finding an opponent"
//        view.font = UIFont.montserratBlack(size: 20)
//        view.textAlignment = .center
//        view.textColor = .whiteColor
//        return view
//    }()
//
//    private lazy var findingInfoTitle: UILabel = {
//        let view = UILabel(frame: .zero)
//        view.text = "Looking for an opponent for you, this will take some time"
//        view.font = UIFont.montserratBold(size: 12)
//        view.textAlignment = .center
//        view.textColor = .grayLabel
//        view.numberOfLines = 2
//        return view
//    }()
//
//    private lazy var cancelButton: UIButton = {
//        let view = UIButton(frame: .zero)
//        view.setTitle("Cancel", for: .normal)
//        view.backgroundColor = UIColor.whiteColor.withAlphaComponent(0.15)
//        view.makeRoundCorners(16)
//        view.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
//        return view
//    }()
//
//    private var dotTimer: Timer?
//    private var dotCount = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.mainViewsBackViewBlack
//
//        setup()
//        setupConstraints()
//        startDotAnimation()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
//            self?.goToNextGameController()
//        }
//    }
//
//    private func setup() {
//        view.addSubview(findingTitle)
//        view.addSubview(findingInfoTitle)
//        view.addSubview(cancelButton)
//    }
//
//    private func setupConstraints() {
//        findingTitle.snp.remakeConstraints { make in
//            make.top.equalTo(view.snp.top).offset(387 * Constraint.yCoeff)
//            make.leading.trailing.equalToSuperview().inset(57 * Constraint.xCoeff)
//            make.height.equalTo(24 * Constraint.yCoeff)
//        }
//
//        findingInfoTitle.snp.remakeConstraints { make in
//            make.top.equalTo(findingTitle.snp.bottom).offset(16 * Constraint.yCoeff)
//            make.leading.trailing.equalToSuperview().inset(57 * Constraint.xCoeff)
//            make.height.equalTo(30 * Constraint.yCoeff)
//        }
//
//        cancelButton.snp.remakeConstraints { make in
//            make.bottom.equalTo(view.snp.bottom).offset(-78 * Constraint.yCoeff)
//            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
//            make.height.equalTo(52 * Constraint.yCoeff)
//        }
//    }
//
//    private func startDotAnimation() {
//        dotTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateDots), userInfo: nil, repeats: true)
//    }
//
//    private func stopDotAnimation() {
//        dotTimer?.invalidate()
//        dotTimer = nil
//    }
//
//    private func goToNextGameController() {
//        stopDotAnimation()
//        if let nextVC = nextViewController {
//            navigationController?.pushViewController(nextVC, animated: true)
//        }
//    }
//
//    @objc private func updateDots() {
//        dotCount = (dotCount + 1) % 4
//        let dots = String(repeating: ".", count: dotCount)
//        findingTitle.text = "Finding an opponent\(dots)"
//    }
//
//    @objc private func clickCancelButton() {
//        stopDotAnimation()
//        navigationController?.popViewController(animated: true)
//    }
//}
