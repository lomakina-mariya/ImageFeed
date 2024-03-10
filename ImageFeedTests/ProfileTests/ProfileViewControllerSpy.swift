
import Foundation
import UIKit
import ImageFeed

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    var avatarView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var loadAvatarCalled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func loadAvatar(url: URL) {
      loadAvatarCalled = true
    }
    
    func showAlert(alert: UIAlertController) {
    }
    
    func dismiss() {
    }
    
    
    
    
    
    
    
    
}
