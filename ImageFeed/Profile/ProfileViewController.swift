
import UIKit

final class ProfileViewController: UIViewController {
    private var avatarViewVar: UIImageView?
    private var nameLabelVar: UILabel?
    private var loginLabelVar: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAvatarView()
        createNameLabel()
        createLoginLabel()
        createDescriptionLabel()
        createLogoutButton()
    }
    
    private func createAvatarView() {
        let avatarView = UIImageView(image: UIImage(named: "UserpickPhoto"))
        avatarView.layer.cornerRadius = 35
        avatarView.layer.masksToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarView)
        avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.avatarViewVar = avatarView
    }
    
    private func createNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: self.avatarViewVar!.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarViewVar!.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.nameLabelVar = nameLabel
    }
    
    private func createLoginLabel() {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.font = .systemFont(ofSize: 13)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: nameLabelVar!.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: nameLabelVar!.leadingAnchor).isActive = true
        loginLabel.trailingAnchor.constraint(equalTo: nameLabelVar!.trailingAnchor).isActive = true
        self.loginLabelVar = loginLabel
    }
    
    private func createDescriptionLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
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
        logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarViewVar!.trailingAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc
    private func didTapLogoutButton() {
        
    }
}
