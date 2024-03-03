
import Foundation
import WebKit

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func makeAlert()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private var profileImageServiceObserver: NSObjectProtocol?
    weak var view: ProfileViewControllerProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Private func
    
    private func logout() {
        OAuth2TokenStorage().token = nil
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
    
    private func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    // MARK: - Internal func
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main) {[weak self] _ in
                    guard let self = self else { return }
                    self.makeAvatarUrl()
                }
        makeAvatarUrl()
    }
    
    func makeAvatarUrl() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.loadAvatar(url: url)
    }
    
    func makeAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        let alertActionYes = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.logout()
            self.clean()
        }
        let alertActionNo = UIAlertAction(title: "Нет", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.view?.dismiss()
        }
        alert.addAction(alertActionYes)
        alert.addAction(alertActionNo)
        self.view?.showAlert(alert: alert)
    }
}
