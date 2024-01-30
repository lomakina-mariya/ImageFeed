
import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthScreenId = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private var blockingProgressHUD = UIBlockingProgressHUD()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if OAuth2TokenStorage().token != nil {
            fetchProfile(OAuth2TokenStorage().token!)
        } else {
            performSegue(withIdentifier: showAuthScreenId, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthScreenId {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthScreenId)")}
            viewController.delegate = self
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
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
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result1 in
            guard let self = self else { return }
            switch result1 {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { result2 in
                    switch result2 {
                    case .success(let imageUrl):
                        print(imageUrl)
                    case .failure(let error):
                        print(" аватарка не получена \(error)")
                        break
                    }
                }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("профиль не получен \(error)")
                break
            }
        }
    }
}

