import UIKit
import SnapKit
import AuthenticationServices
import Alamofire
import ProgressHUD
import StoreKit

class SignInController: UIViewController {
    private lazy var mainImageConsole: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "signinViewImage")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var signTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "SIGN IN"
        view.textColor = UIColor.whiteColor
        view.font = UIFont.montserratBold(size: 32)
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var signInInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Sign in with your Apple account to transfer your account data and keep it safe."
        view.textColor = UIColor.grayLabel
        view.font = UIFont.montserratBold(size: 16)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var signInWithAppleButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Sign in with apple", for: .normal)
        view.setTitleColor(UIColor.titlesBlack, for: .normal)
        view.backgroundColor = UIColor.whiteColor
        view.makeRoundCorners(16)
        view.titleLabel?.font = UIFont.montserratBlack(size: 12)
        view.layer.borderColor = UIColor.whiteColor.cgColor
        view.layer.borderWidth = 1
        let image = UIImage(named: "apple")?.withRenderingMode(.alwaysOriginal)
        let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 24)).image { _ in
            image?.draw(in: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
        }
        view.setImage(resizedImage, for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        view.contentHorizontalAlignment = .center
        view.addTarget(self, action: #selector(clickSignInWithAppleButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var skipButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Skip", for: .normal)
        view.backgroundColor = UIColor.whiteColor.withAlphaComponent(0.15)
        view.makeRoundCorners(16)
        view.addTarget(self, action: #selector(clickSkipButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var termsButton: UIButton = {
        let view = UIButton(frame: .zero)
        let attributedTitle = NSAttributedString(
            string: "Terms of Use",
            attributes: [
                .font: UIFont.montserratRegular(size: 12),
                .foregroundColor: UIColor.whiteColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        view.setAttributedTitle(attributedTitle, for: .normal)
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(clickTermsButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var privacyPolicyButton: UIButton = {
        let view = UIButton(frame: .zero)
        let attributedTitle = NSAttributedString(
            string: "Privacy Policy",
            attributes: [
                .font: UIFont.montserratRegular(size: 12),
                .foregroundColor: UIColor.whiteColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        view.setAttributedTitle(attributedTitle, for: .normal)
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(clickPrivacyPolicyButton), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainViewsBackViewBlack
        setup()
        setupConstraints()
    }
    
    private func setup() {
        view.addSubview(mainImageConsole)
        view.addSubview(signTitle)
        view.addSubview(signInInfoLabel)
        view.addSubview(signInWithAppleButton)
        view.addSubview(skipButton)
        view.addSubview(termsButton)
        view.addSubview(privacyPolicyButton)
    }
    
    private func setupConstraints() {
        mainImageConsole.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(120 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(-20 * Constraint.xCoeff)
            make.trailing.equalTo(view.snp.trailing).offset(20 * Constraint.xCoeff)
            make.height.equalTo(380 * Constraint.yCoeff)
        }
        signTitle.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).offset(368 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(32 * Constraint.xCoeff)
            make.height.equalTo(39 * Constraint.yCoeff)
        }
        signInInfoLabel.snp.remakeConstraints { make in
            make.top.equalTo(signTitle.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(32 * Constraint.xCoeff)
            make.height.equalTo(60 * Constraint.yCoeff)
        }
        signInWithAppleButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-150 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }
        skipButton.snp.remakeConstraints { make in
            make.top.equalTo(signInWithAppleButton.snp.bottom).offset(8 * Constraint.yCoeff)
            make.leading.trailing.equalToSuperview().inset(20 * Constraint.xCoeff)
            make.height.equalTo(52 * Constraint.yCoeff)
        }
        termsButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-32 * Constraint.yCoeff)
            make.leading.equalTo(view.snp.leading).offset(20 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }
        privacyPolicyButton.snp.remakeConstraints { make in
            make.centerY.equalTo(termsButton.snp.centerY)
            make.trailing.equalTo(view.snp.trailing).offset(-20 * Constraint.xCoeff)
            make.height.equalTo(15 * Constraint.yCoeff)
        }
    }
    
    @objc private func clickTermsButton() {
        openHelper(url: "https://bovagames.fun/terms") { [weak self] button in
            switch button {
            case "close":
                self?.dismiss(animated: true)
            default:
                break
            }
        }
    }
    
    @objc private func clickPrivacyPolicyButton() {
        openHelper(url: "https://bovagames.fun/privacy") { [weak self] button in
            switch button {
            case "close":
                self?.dismiss(animated: true)
            default:
                break
            }
        }
    }
    
    @objc private func clickSkipButton() {
        UserDefaults.standard.setValue(true, forKey: "isGuestUser")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "AccountCredential")
        let mainViewTabBarController = MainViewControllerTab()
        navigationController?.pushViewController(mainViewTabBarController, animated: true)
    }
    
    @objc private func clickSignInWithAppleButton() {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func createUser() {
        NetworkManager.shared.showProgressHud(true, animated: true)
        let pushToken = UserDefaults.standard.string(forKey: "PushToken") ?? ""
        let appleToken = UserDefaults.standard.string(forKey: "AccountCredential") ?? ""
        let parameters: [String: Any] = [
            "push_token": pushToken,
            "apple_token": appleToken,
        ]
        NetworkManager.shared.post(
            url: String.userCreate(),
            parameters: parameters,
            headers: nil
        ) { [weak self] (result: Result<UserCreate>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                NetworkManager.shared.showProgressHud(false, animated: false)
                UserDefaults.standard.setValue(false, forKey: "isGuestUser")
            }
            print("\(parameters)")
            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    print("User created: \(userInfo)")
                    UserDefaults.standard.setValue(userInfo.id, forKey: "userId")
                    print("Received User ID: \(userInfo.id)")
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        let mainViewController = MainViewControllerTab()
                        let navigationController = UINavigationController(rootViewController: mainViewController)
                        sceneDelegate.changeRootViewController(navigationController)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", description: error.localizedDescription)
                }
                print("Error: \(error)")
            }
        }
    }
    
    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SignInController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        UserDefaults.standard.setValue(credential.user, forKey: "AccountCredential")
        createUser()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError
        if nsError.domain == ASAuthorizationError.errorDomain {
            switch nsError.code {
            case ASAuthorizationError.canceled.rawValue:
                return
            case ASAuthorizationError.failed.rawValue:
                showAlert(title: "Sign In Failed", description: "Something went wrong. Please try again.")
            case ASAuthorizationError.invalidResponse.rawValue:
                showAlert(title: "Invalid Response", description: "We couldn't authenticate you. Please try again.")
            case ASAuthorizationError.notHandled.rawValue:
                showAlert(title: "Not Handled", description: "The request wasn't handled. Please try again.")
            case ASAuthorizationError.unknown.rawValue:
                showAlert(title: "Unknown Error", description: "An unknown error occurred. Please try again.")
            default:
                break
            }
        } else {
            showAlert(title: "Sign In Failed", description: error.localizedDescription)
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
