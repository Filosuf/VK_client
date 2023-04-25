//
//  ProfileViewController.swift
//  ClientVk
//
//  Created by Filosuf on 09.04.2023.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    func setupView(profile: Profile)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

    // MARK: - Properties
    private let presenter: ProfileViewPresenterProtocol

    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    private let phoneLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    private lazy var logOutButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = "logout".localized
        let button = UIButton(configuration: config, primaryAction: UIAction(handler: { [unowned self] _ in
            presenter.logout()
        }))

        return button
    }()

    // MARK: - Initialiser
    init(presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        presenter.viewDidLoad()
    }

    // MARK: - Methods
    func setupView(profile: Profile) {
        if let photoUrl = URL(string: profile.photoUrl) {
            profileImage.load(url: photoUrl)
        }
        nameLabel.text = profile.fullName
        cityLabel.text = profile.city
        phoneLabel.text = profile.mobilePhone
    }

    private func layout() {
        [profileImage, nameLabel, cityLabel, phoneLabel,logOutButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            cityLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            cityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            cityLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50),
            phoneLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
