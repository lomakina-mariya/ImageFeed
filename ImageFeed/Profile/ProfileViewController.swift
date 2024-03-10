
import UIKit
import Kingfisher


public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    var avatarView: UIImageView { get set }
    func loadAvatar(url: URL)
    func showAlert()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private let profileService = ProfileService.shared
    private var nameLabelVar: UILabel?
    private var loginLabelVar: UILabel?
    var avatarView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    var presenter: ProfilePresenterProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter(view: self)
        presenter?.viewDidLoad()
        
        guard let profile = profileService.profile else {return}
        
        view.backgroundColor = UIColor(named: "YP Black")
        createAvatarView()
        createNameLabel(profile.name)
        createLoginLabel(profile.loginName)
        createDescriptionLabel(profile.bio)
        createLogoutButton()
    }
    
    // MARK: - Private func
    
    private func createAvatarView() {
        avatarView.layer.cornerRadius = 35
        avatarView.layer.masksToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarView)
        avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func createNameLabel(_ name: String) {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: self.avatarView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.nameLabelVar = nameLabel
    }
    
    private func createLoginLabel(_ login: String) {
        let loginLabel = UILabel()
        loginLabel.text = login
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.font = .systemFont(ofSize: 13)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: nameLabelVar!.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: nameLabelVar!.leadingAnchor).isActive = true
        loginLabel.trailingAnchor.constraint(equalTo: nameLabelVar!.trailingAnchor).isActive = true
        self.loginLabelVar = loginLabel
    }
    
    private func createDescriptionLabel(_ bio: String) {
        let descriptionLabel = UILabel()
        descriptionLabel.text = bio
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: loginLabelVar!.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: nameLabelVar!.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: nameLabelVar!.trailingAnchor).isActive = true
    }
    
    private func createLogoutButton() {
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "Logout Button"), for: .normal)
        logoutButton.addTarget(self, action: #selector(Self.didTapLogoutButton), for: UIControl.Event.touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarView.trailingAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.accessibilityIdentifier = "Logout"
    }
    
    @objc
    private func didTapLogoutButton() {
        showAlert()
    }
    
    // MARK: - Internal func
    
    func loadAvatar(url: URL) {
        avatarView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 40)
        avatarView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "userpickStub"),
            options: [.processor(processor)])
    }
    
    func showAlert() {
        guard let alert = self.presenter?.makeAlert() else { return }
        let alertActionYes = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.presenter?.logout()
            self.presenter?.clean()
        }
        let alertActionNo = UIAlertAction(title: "Нет", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        alert.addAction(alertActionYes)
        alert.addAction(alertActionNo)
        self.present(alert, animated: true)
    }
}
