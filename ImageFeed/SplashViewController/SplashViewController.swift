
import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthScreenId = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private var blockingProgressHUD = UIBlockingProgressHUD()
    private var logoView: UIImageView?
    
    // MARK: - override func
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor(named: "YP Black")
        createLogoView()
        if OAuth2TokenStorage().token != nil {
            fetchProfile(OAuth2TokenStorage().token!)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
    // MARK: - private func
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func createLogoView() {
        let logoView = UIImageView(image: UIImage(named: "splash_screen_logo"))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //logoView.heightAnchor.constraint(equalToConstant: 73).isActive = true
        //logoView.widthAnchor.constraint(equalToConstant: 76).isActive = true
    }
}

// MARK: - Extensions SplashViewController - private func

extension SplashViewController: AuthViewControllerDelegate {
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token)
                UIBlockingProgressHUD.show()
            case .failure(let error):
                UIBlockingProgressHUD.show()
                print("токен не получен \(error)")
                self.showAlert()
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { result1 in
                    switch result1 {
                    case .failure(let error):
                        print("ссылка на аватарку не получена \(error)")
                        self.showAlert()
                        break
                    case .success:
                        print("ссылка на аватарку получена")
                    }
                }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("профиль не получен \(error)")
                self.showAlert()
                break
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        let vc = self.presentedViewController ?? self
        vc.present(alert, animated: true)
    }
    
    // MARK: - Extensions SplashViewController - func
    
    func authViewViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
}

