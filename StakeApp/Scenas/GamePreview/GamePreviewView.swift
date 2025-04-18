import UIKit
import SnapKit

class GamePreviewView: UIViewController {
    lazy var goldenBallImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "goldenBall")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var minerImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "minerWorker")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var pandaImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "pandaImage")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var pandaGameDescriptionImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "bambooImage")
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var goldView: GoldsImageView = {
        let view = GoldsImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()

    lazy var minerGameView: MinerView = {
        let view = MinerView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.onStartButton = { [weak self] in
            self?.goMainerGameView()
        }
        view.onCancelButtonTapped = { [weak self] in
            self?.goBackView()
        }
        return view
    }()

    lazy var pandaGameView: PandasView = {
        let view = PandasView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.onStartGameButton = { [weak self] in
            self?.goPandaGameController()
        }
        view.onCancelButtonTapped = { [weak self] in
            self?.goBackView()
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackColor
        setup()
        setupConstraints()
    }

    private func setup() {
        view.addSubview(goldenBallImage)
        view.addSubview(minerImage)
        view.addSubview(pandaImage)
        view.addSubview(pandaGameDescriptionImage)
        view.addSubview(goldView)
        view.addSubview(minerGameView)
        view.addSubview(pandaGameView)
    }

    private func setupConstraints() {
        goldenBallImage.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.height.width.equalTo(178 * Constraint.yCoeff)
        }

        minerImage.snp.remakeConstraints { make in
            make.top.equalTo(minerGameView.snp.top).offset(-306 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(195 * Constraint.xCoeff)
            make.height.equalTo(373 * Constraint.yCoeff)
            make.width.equalTo(192 * Constraint.xCoeff)
        }

        goldView.snp.remakeConstraints { make in
            make.top.equalTo(minerGameView.snp.top).offset(-82 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(-5 * Constraint.xCoeff)
            make.height.equalTo(97 * Constraint.yCoeff)
            make.width.equalTo(163 * Constraint.xCoeff)
        }

        pandaImage.snp.remakeConstraints { make in
            make.top.equalTo(pandaGameView.snp.top).offset(-306 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(195 * Constraint.xCoeff)
            make.height.equalTo(373 * Constraint.yCoeff)
            make.width.equalTo(215 * Constraint.xCoeff)
        }

        pandaGameDescriptionImage.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(101 * Constraint.yCoeff)
            make.trailing.equalTo(pandaImage.snp.leading).offset(120 * Constraint.xCoeff)
            make.height.equalTo(196 * Constraint.yCoeff)
            make.height.equalTo(210 * Constraint.xCoeff)
        }

        minerGameView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(492)
        }

        pandaGameView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(583)
        }
    }

    func goMainerGameView() {
        let findingAnOpponents = FindingAnOpponentsController()
        findingAnOpponents.nextViewController = MinerGameController()
        navigationController?.pushViewController(findingAnOpponents, animated: true)
    }

    func configureForMinerGame() {
        goldenBallImage.isHidden = false
        goldView.isHidden = false
        minerImage.isHidden = false
        minerGameView.isHidden = false
    }

    func configureForPandaGame() {
        pandaGameDescriptionImage.isHidden = false
        pandaImage.isHidden = false
        pandaGameView.isHidden = false
    }

    private func goPandaGameController() {
        let findingAnOpponents = FindingAnOpponentsController()
        findingAnOpponents.nextViewController = PandaAndBaboonsGameController()
        navigationController?.pushViewController(findingAnOpponents, animated: true)
    }

    @objc private func goBackView() {
        navigationController?.popViewController(animated: true)
    }
}
